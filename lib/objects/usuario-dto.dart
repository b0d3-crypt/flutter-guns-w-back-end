class UsuarioDTO {
  int idPessoa;
  int idUsuario;
  String nome;
  String nick;
  String email;
  String password;

  UsuarioDTO({
    required this.idPessoa,
    required this.idUsuario,
    required this.nome,
    required this.nick,
    required this.email,
    required this.password,
  });

  UsuarioDTO.empty()
      : idPessoa = 0,
        idUsuario = 0,
        nome = '',
        nick = '',
        email = '',
        password = '';

  factory UsuarioDTO.fromJson(Map<String, dynamic> json) {
    return UsuarioDTO(
      idPessoa: json['idPessoa'],
      idUsuario: json['idUsuario'],
      nome: json['nome'],
      nick: json['nick'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idPessoa': idPessoa,
      'idUsuario': idUsuario,
      'nome': nome,
      'nick': nick,
      'email': email,
      'password': password,
    };
  }
}
