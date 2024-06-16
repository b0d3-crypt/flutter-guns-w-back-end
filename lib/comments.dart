import 'package:flutter/material.dart';

class Comments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comentários',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              // Campo para adicionar novos comentários
              TextField(
                decoration: InputDecoration(
                  hintText: 'Adicione um comentário...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              // Lista de comentários
              Container(
                height: 200, // Ajuste a altura conforme necessário
                child: ListView(
                  children: [
                    ListTile(
                      title: Text('Usuário 1'),
                      subtitle: Text('Comentário 1'),
                    ),
                    ListTile(
                      title: Text('Usuário 2'),
                      subtitle: Text('Comentário 2'),
                    ),
                    // Adicione mais listTiles conforme necessário para os comentários
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
