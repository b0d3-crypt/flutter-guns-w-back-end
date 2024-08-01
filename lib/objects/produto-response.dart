class ProdutoResponse {
  int idProduto;
  String nmProduto;
  String descricao;
  String imagem;
  String comentario;
  String nick;
  String email;
  int nrLike;

  ProdutoResponse({
    required this.idProduto,
    required this.nmProduto,
    required this.descricao,
    required this.imagem,
    required this.comentario,
    required this.nick,
    required this.email,
    required this.nrLike,
  });

  factory ProdutoResponse.fromJson(Map<String, dynamic> json) {
    return ProdutoResponse(
      idProduto: json['idProduto'],
      nmProduto: json['nmProduto'],
      descricao: json['descricao'],
      imagem: json['imagem'],
      comentario: json['comentario'],
      nick: json['nick'],
      email: json['email'],
      nrLike: json['nrLike'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProduto': idProduto,
      'nmProduto': nmProduto,
      'descricao': descricao,
      'imagem': imagem,
      'comentario': comentario,
      'nick': nick,
      'email': email,
      'nrLike': nrLike,
    };
  }
}
