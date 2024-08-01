import 'usuario.dart';

class ComentarioResponse {
  int idProduto;
  Usuario usuario;
  String comentario;

  ComentarioResponse({
    required this.idProduto,
    required this.usuario,
    required this.comentario,
  });

  factory ComentarioResponse.fromJson(Map<String, dynamic> json) {
    return ComentarioResponse(
      idProduto: json['idProduto'],
      usuario: Usuario.fromJson(json['usuario']),
      comentario: json['comentario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProduto': idProduto,
      'usuario': usuario.toJson(),
      'comentario': comentario,
    };
  }
}
