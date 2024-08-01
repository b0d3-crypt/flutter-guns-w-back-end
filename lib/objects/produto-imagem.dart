class ProdutoImagem {
  int idProduto;
  String nome;
  String descricao;
  String imagem;

  ProdutoImagem({
    required this.idProduto,
    required this.nome,
    required this.descricao,
    required this.imagem,
  });

  factory ProdutoImagem.fromJson(Map<String, dynamic> json) {
    return ProdutoImagem(
      idProduto: json['idProduto'],
      nome: json['nome'],
      descricao: json['descricao'],
      imagem: json['imagem'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProduto': idProduto,
      'nome': nome,
      'descricao': descricao,
      'imagem': imagem,
    };
  }
}
