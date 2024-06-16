import 'package:flutter/material.dart';
import 'package:gun_store/gun_model.dart';

class GunsDetails extends StatelessWidget {
  final Gun gun;

  GunsDetails({required this.gun});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gun.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                gun.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ),
            SizedBox(height: 16),
            // Exibindo nome da arma
            Text(
              gun.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Exibindo descrição da arma
            Text(
              gun.description,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
