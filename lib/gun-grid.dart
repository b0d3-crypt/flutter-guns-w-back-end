import 'package:flutter/material.dart';
import 'package:gun_store/objects/produto-imagem.dart';

class GunGrid extends StatelessWidget {
  final List<ProdutoImagem> guns;
  final void Function(ProdutoImagem gun) onItemClick;
  final ScrollController scrollController;

  GunGrid({
    required this.guns,
    required this.onItemClick,
    required this.scrollController, // Adicionado o ScrollController
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController, // Adicionado o controller
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 8 / 16,
      ),
      itemCount: guns.length,
      itemBuilder: (context, index) {
        final ProdutoImagem gun = guns[index];
        return GestureDetector(
          onTap: () => onItemClick(gun),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    gun.imagem,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: Text(
                    gun.nome,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    gun.descricao,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
