class Produto {
  int id;
  String nome;
  String descricao;

  Produto({
    required this.id,
    required this.nome,
    required this.descricao,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
    };
  }
}
