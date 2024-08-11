class ProdutoLike {
  int idProduto;
  int nrLike;

  ProdutoLike({required this.idProduto, required this.nrLike});

  factory ProdutoLike.fromJson(Map<String, dynamic> json) {
    return ProdutoLike(
      idProduto: json['idProduto'],
      nrLike: json['nrLike'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProduto': idProduto,
      'nrLike': nrLike,
    };
  }
}
