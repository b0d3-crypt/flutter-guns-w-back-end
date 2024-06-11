import 'package:flutter/material.dart';
import 'package:gun_store/items.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gun Store',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          background: Colors.grey.shade400,
          onBackground: Colors.black,
          primary: Colors.grey.shade800,
          onPrimary: Colors.white,
          secondary: Colors.green.shade700,
          onSecondary: Colors.white,
          error: Colors.red.shade700,
          onError: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade800,
          foregroundColor: Colors.white,
        ),
      ),
      home: ItemsWidget(),
    );
  }
}
