import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gun_store/comentario.dart';
import 'package:gun_store/objects/comentario-response.dart';
import 'package:gun_store/objects/details-gun.dart';
import 'package:gun_store/objects/pessoa.dart';
import 'package:gun_store/objects/usuario-dto.dart';
import 'package:gun_store/objects/usuario.dart';
import 'package:http/http.dart' as http;

class Comment {
  final String text;
  final UsuarioDTO usuarioDTO;

  Comment({required this.text, required this.usuarioDTO});
}

class Comments extends StatefulWidget {
  final UsuarioDTO usuarioDTO;
  final int idProduto;
  final DetailsGuns detailsGuns;

  Comments(
      {required this.usuarioDTO,
      required this.idProduto,
      required this.detailsGuns});

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final TextEditingController _controller = TextEditingController();
  late List<Comentario> _comments = [];

  void _addComment() {
    if (_controller.text.isNotEmpty && widget.usuarioDTO.idUsuario > 0) {
      ComentarioResponse comentario = setComentario();

      setState(() {
        _comments.insert(
          0,
          Comentario(
            text: _controller.text,
            user: widget.usuarioDTO.nome,
          ),
        );

        inserirComentario(comentario);
        _controller.clear();
      });
    }
  }

  ComentarioResponse setComentario() {
    Pessoa pessoa = Pessoa(
        id: widget.usuarioDTO.idPessoa,
        nome: widget.usuarioDTO.nome,
        email: widget.usuarioDTO.email);
    Usuario usuario = Usuario(
        id: widget.usuarioDTO.idUsuario,
        pessoa: pessoa,
        nick: widget.usuarioDTO.nick,
        password: widget.usuarioDTO.password);
    final comentarioResponse = ComentarioResponse(
      idProduto: widget.idProduto,
      usuario: usuario,
      comentario: _controller.text,
    );
    return comentarioResponse;
  }

  inserirComentario(ComentarioResponse comentario) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/comentarios'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(comentario),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Comentário inserido com sucesso.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao inserir comentário.'),
        ),
      );
    }
  }

  List<Comentario> setComentarios() {
    int tamanho = widget.detailsGuns.comentarioProdutoResponse.length;
    int length = _comments.length;
    if (tamanho > 0) {
      if (length == 0 ||
          widget.detailsGuns.comentarioProdutoResponse[tamanho - 1]
                  .comentario !=
              _comments[length - 1].text) {
        for (var comentario in widget.detailsGuns.comentarioProdutoResponse) {
          Comentario coment = Comentario(
              text: comentario.comentario, user: widget.usuarioDTO.nome);
          this._comments.add(coment);
        }
      }
    }

    return _comments;
  }

  @override
  Widget build(BuildContext context) {
    setComentarios();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Comentários',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (widget.usuarioDTO.idUsuario > 0)
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 100),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Adicione um comentário...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _addComment,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey.shade800,
                    ),
                    child: const Text('Adicionar Comentário'),
                  ),
                ],
              ),
            ),
          ),
        if (widget.usuarioDTO.nome == '')
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Faça login para adicionar um comentário.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: _comments.length,
            itemBuilder: (context, index) {
              final comment = _comments[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            comment.user!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(comment.text),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
