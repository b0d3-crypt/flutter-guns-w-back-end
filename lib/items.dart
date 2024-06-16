import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gun_store/bar-title.dart';
import 'package:gun_store/gun-grid.dart';
import 'package:gun_store/gun_model.dart';

class ItemsWidget extends StatefulWidget {
  @override
  _ItemsWidgetState createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget> {
  late List<Gun> guns = [];
  int itemCountToShow = 4;
  bool isLoading = false;

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
    await _loadGuns();
    setState(() {
      itemCountToShow = 4;
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
                ),
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
