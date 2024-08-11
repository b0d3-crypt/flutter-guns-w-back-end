class ComentarioProdutoResponse {
  final String comentario;
  final String nick;
  final String email;

  ComentarioProdutoResponse({
    required this.comentario,
    required this.nick,
    required this.email,
  });

  factory ComentarioProdutoResponse.fromJson(Map<String, dynamic> json) {
    return ComentarioProdutoResponse(
      comentario: json['comentario'],
      nick: json['nick'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comentario': comentario,
      'nick': nick,
      'email': email,
    };
  }
}
