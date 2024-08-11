import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gun_store/objects/comentario-protudo-response.dart';
import 'package:gun_store/objects/details-gun.dart';
import 'package:gun_store/objects/usuario-dto.dart';
import 'package:http/http.dart' as http;

import 'comments.dart';

class GunsDetails extends StatefulWidget {
  final int cdProduto;
  final UsuarioDTO usuarioDTO;

  GunsDetails({required this.cdProduto, required this.usuarioDTO});

  @override
  _GunsDetailsState createState() => _GunsDetailsState();
}

class _GunsDetailsState extends State<GunsDetails> {
  DetailsGuns? gun;
  bool isLoading = true;
  bool isExpanded = false;
  bool liked = false;

  @override
  void initState() {
    super.initState();
    _fetchGunDetails();
  }

  Future<void> _fetchGunDetails() async {
    final url = 'http://localhost:3000/produtos/${widget.cdProduto}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        if (jsonData.isNotEmpty) {
          setState(() {
            gun = parseDetailsGuns(jsonData);
            isLoading = false;
          });
        } else {
          print('No data found for the provided cdProduto');
        }
      } else {
        print('Failed to load gun details');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  DetailsGuns parseDetailsGuns(List<dynamic> jsonData) {
    if (jsonData.isEmpty) {
      throw Exception("A lista de dados JSON está vazia.");
    }
    DetailsGuns details = DetailsGuns.empty();
    details.idProduto = jsonData[0]['idproduto'];
    details.nmProduto = jsonData[0]['nmproduto'];
    details.descricao = jsonData[0]['descricao'];
    details.imagem = jsonData[0]['imagem'];
    details.nrLike = jsonData[0]['nrlike'];
    var comentariosList = <ComentarioProdutoResponse>[];
    for (var item in jsonData) {
      ComentarioProdutoResponse comentario = ComentarioProdutoResponse(
          comentario: item['comentario'] ?? '',
          nick: item['nick'] ?? '',
          email: item['email'] ?? '');
      comentariosList.add(comentario);
    }
    if (comentariosList.length > 1 && comentariosList[0].comentario != '') {
      details.comentarioProdutoResponse = comentariosList;
    }
    return details;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gun?.nmProduto ?? 'Loading...'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child: Image.network(
                              gun!.imagem,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    gun!.nmProduto,
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Verifique se o usuário está logado antes de exibir o ícone de "like"
                                if (widget.usuarioDTO.idUsuario > 0)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        liked = !liked;
                                      });
                                    },
                                    child: Icon(
                                      liked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: liked ? Colors.red : null,
                                      size: 32,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isExpanded
                                      ? gun!.descricao
                                      : (gun!.descricao.length > 100
                                          ? '${gun!.descricao.substring(0, 100)}...'
                                          : gun!.descricao),
                                  style: TextStyle(fontSize: 18),
                                ),
                                if (gun!.descricao.length > 100)
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isExpanded = !isExpanded;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          isExpanded ? 'Menos' : 'Mais',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        Icon(
                                          isExpanded
                                              ? Icons.expand_less
                                              : Icons.expand_more,
                                          color: Colors.blue,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 400,
                      child: Comments(
                        username:
                            widget.usuarioDTO?.nome, // Passa o nome do usuário
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
