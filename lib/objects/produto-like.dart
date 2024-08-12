class ProdutoLike {
  int produto_id;
  int nrLike;

  ProdutoLike({required this.produto_id, required this.nrLike});

  factory ProdutoLike.fromJson(Map<String, dynamic> json) {
    return ProdutoLike(
      produto_id: json['produto_id'],
      nrLike: json['nrLike'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'produto_id': produto_id,
      'nrLike': nrLike,
    };
  }
}
