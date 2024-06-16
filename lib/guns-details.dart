import 'package:flutter/material.dart';
import 'package:gun_store/gun_model.dart';

class GunsDetails extends StatefulWidget {
  final Gun gun;

  GunsDetails({required this.gun});

  @override
  _GunsDetailsState createState() => _GunsDetailsState();
}

class _GunsDetailsState extends State<GunsDetails> {
  bool isLiked = false; // Estado para controlar se o item foi curtido

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gun.name), // Usando o nome da arma como título
        // Aqui você pode adicionar outros botões de ação, se necessário
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exibindo imagem da arma
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                widget.gun.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ),
            SizedBox(height: 16),
            // Exibindo nome da arma e ícone de curtir na mesma linha
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.gun.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked; // Alternar o estado de curtida
                    });
                  },
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    size: 36, // Tamanho do ícone
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Exibindo descrição da arma
            Text(
              widget.gun.description,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
