class UsuarioLike {
  int produtoId;
  int usuarioId;

  UsuarioLike({required this.produtoId, required this.usuarioId});

  factory UsuarioLike.fromJson(Map<String, dynamic> json) {
    return UsuarioLike(
      produtoId: json['produtoId'],
      usuarioId: json['usuarioId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'produtoId': produtoId,
      'usuarioId': usuarioId,
    };
  }
}
