import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gun_store/bar-title.dart';
import 'package:gun_store/gun-grid.dart'; // Importando o arquivo gun_grid.dart
import 'package:gun_store/gun_model.dart';

class ItemsWidget extends StatefulWidget {
  @override
  _ItemsWidgetState createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget> {
  late List<Gun> guns = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: BarTitle(),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(CupertinoIcons.arrow_right_to_line),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GunGrid(guns: guns), // Usando o widget GunGrid
      ),
    );
  }
}
