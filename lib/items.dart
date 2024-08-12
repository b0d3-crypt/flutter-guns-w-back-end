import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gun_store/bar-title.dart';
import 'package:gun_store/google_auth_service.dart';
import 'package:gun_store/gun-grid.dart';
import 'package:gun_store/guns-details.dart';
import 'package:gun_store/objects/produto-imagem.dart';
import 'package:gun_store/objects/usuario-dto.dart';
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
  late UsuarioDTO usuarioDTO = UsuarioDTO.empty();
  int offset = 0;
  int limit = 4;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadGuns();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!isLoading) {
        _loadGuns();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadGuns() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http
          .get(Uri.parse('http://localhost:3000/produtos/${offset}/${limit}'));
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
            offset += limit;
            for (var gun in loadedGuns) {
              guns.add(gun);
            }
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
    offset = 0;
    guns.clear();
    await _loadGuns();
  }

  Future<void> _toggleIcon() async {
    if (isRightArrow) {
      final GoogleSignInAccount? googleUser =
          await GoogleAuthService.signInWithGoogle();
      if (googleUser != null) {
        UsuarioDTO usuario = UsuarioDTO(
          idPessoa: 0,
          idUsuario: 0,
          nome: googleUser.displayName ?? '',
          nick: '',
          email: googleUser.email,
          password: '',
        );
        final response = await http.post(
          Uri.parse('http://localhost:3000/user/user'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(usuario.toJson()),
        );

        if (response.statusCode == 201) {
          final Map<String, dynamic> responseData = json.decode(response.body);

          UsuarioDTO usuarioRecebido = parseUsuarioDTO(responseData);
          usuarioDTO = usuarioRecebido;
          username = usuarioRecebido.nome;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send user data'),
            ),
          );
        }

        setState(() {
          username = googleUser.displayName;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Usuário ${username} logado com sucesso.'),
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
        usuarioDTO = UsuarioDTO.empty();
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

  UsuarioDTO parseUsuarioDTO(Map<String, dynamic> jsonData) {
    if (jsonData.isEmpty) {
      throw Exception("A lista de dados JSON está vazia.");
    }
    UsuarioDTO usuario = UsuarioDTO(
        idUsuario: jsonData['id'],
        idPessoa: jsonData['pessoa']['id'],
        nome: jsonData['pessoa']['nome'],
        nick: jsonData['nick'],
        email: jsonData['pessoa']['email'],
        password: jsonData['password']);
    return usuario;
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
                            builder: (context) => GunsDetails(
                                cdProduto: gun.idProduto,
                                usuarioDTO: usuarioDTO),
                          ),
                        );
                      },
                      scrollController: _scrollController,
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
