import 'pessoa.dart';

class Usuario {
  int id;
  Pessoa pessoa;
  String nick;
  String password;

  Usuario({
    required this.id,
    required this.pessoa,
    required this.nick,
    required this.password,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      pessoa: Pessoa.fromJson(json['pessoa']),
      nick: json['nick'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pessoa': pessoa.toJson(),
      'nick': nick,
      'password': password,
    };
  }
}
