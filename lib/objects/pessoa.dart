class Pessoa {
  int id;
  String nome;
  String email;

  Pessoa({
    required this.id,
    required this.nome,
    required this.email,
  });

  factory Pessoa.fromJson(Map<String, dynamic> json) {
    return Pessoa(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
    };
  }
}
