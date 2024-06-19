import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gun_store/bar-title.dart';
import 'package:gun_store/google_auth_service.dart';
import 'package:gun_store/gun-grid.dart';
import 'package:gun_store/gun_model.dart';
import 'package:gun_store/guns-details.dart';

class ItemsWidget extends StatefulWidget {
  @override
  _ItemsWidgetState createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget> {
  late List<Gun> guns = [];
  int itemCountToShow = 4;
  bool isLoading = false;
  bool isRightArrow = true;
  String? username;

  @override
  void initState() {
    super.initState();
    _loadGuns();
  }

  Future<void> _loadGuns() async {
    final String data = await rootBundle.loadString('assets/guns.json');
    final List<dynamic> jsonData = json.decode(data);
    setState(() {
      guns = jsonData.map((json) => Gun.fromJson(json)).toList();
    });
  }

  Future<void> _refreshGuns() async {
    setState(() {
      isLoading = true;
    });

    await _loadGuns();

    setState(() {
      itemCountToShow = 4;
      isLoading = false;
    });
  }

  void _loadMoreItems() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        if (itemCountToShow + 4 <= guns.length) {
          itemCountToShow += 4;
        } else {
          itemCountToShow = guns.length;
        }
        isLoading = false;
      });
    });
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
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!isLoading &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                _loadMoreItems();
              }
              return true;
            },
            child: Stack(
              children: [
                GunGrid(
                  guns: guns.take(itemCountToShow).toList(),
                  isLoading: isLoading,
                  onItemClick: (Gun gun) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GunsDetails(
                          gun: gun,
                          username: username,
                        ),
                      ),
                    );
                  },
                ),
                if (isLoading || guns.isEmpty)
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
      ),
    );
  }
}
