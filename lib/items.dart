import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gun_store/bar-title.dart';
import 'package:gun_store/google_auth_service.dart';
import 'package:gun_store/gun-grid.dart';
import 'package:gun_store/guns-details.dart';
import 'package:gun_store/objects/produto-imagem.dart';
import 'package:http/http.dart' as http;

class ItemsWidget extends StatefulWidget {
  @override
  _ItemsWidgetState createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget> {
  late List<ProdutoImagem> guns = [];
  bool isLoading = false;
  bool isRightArrow = true;
  String? username;

  @override
  void initState() {
    super.initState();
    _loadGuns();
  }

  Future<void> _loadGuns() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/produtos'));
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');

        final List<dynamic> jsonData = json.decode(response.body);
        if (jsonData is List) {
          List<ProdutoImagem> loadedGuns = [];
          for (var item in jsonData) {
            print('Response body: ${item}');
            try {
              loadedGuns.add(ProdutoImagem.fromJson(item));
            } catch (e) {
              print('Error parsing item: $e');
              print('Failed item: $item');
            }
          }

          setState(() {
            guns = loadedGuns;
          });
        } else {
          print('Error: JSON data is not a list');
        }
      } else {
        print('Failed to load guns with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during request: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshGuns() async {
    await _loadGuns();
  }

  Future<void> _toggleIcon() async {
    if (isRightArrow) {
      final GoogleSignInAccount? googleUser =
          await GoogleAuthService.signInWithGoogle();
      if (googleUser != null) {
        setState(() {
          username = googleUser.displayName;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logged in as $username'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to log in'),
          ),
        );
      }
    } else {
      await GoogleAuthService.signOutGoogle();
      setState(() {
        username = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged out'),
        ),
      );
    }

    setState(() {
      isRightArrow = !isRightArrow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: BarTitle(),
        actions: [
          IconButton(
            onPressed: _toggleIcon,
            icon: Icon(isRightArrow ? Icons.login : Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: _refreshGuns,
          child: Stack(
            children: [
              guns.isNotEmpty
                  ? GunGrid(
                      guns: guns,
                      onItemClick: (ProdutoImagem gun) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GunsDetails(cdProduto: gun.idProduto),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No guns available',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
              if (isLoading)
                Center(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0.1),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
