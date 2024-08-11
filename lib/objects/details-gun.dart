import 'package:gun_store/objects/comentario-protudo-response.dart';

class DetailsGuns {
  int idProduto;
  String nmProduto;
  String descricao;
  String imagem;
  int nrLike;
  List<ComentarioProdutoResponse> comentarioProdutoResponse;

  DetailsGuns({
    required this.idProduto,
    required this.nmProduto,
    required this.descricao,
    required this.imagem,
    required this.nrLike,
    required this.comentarioProdutoResponse,
  });

  DetailsGuns.empty()
      : idProduto = 0,
        nmProduto = '',
        descricao = '',
        imagem = '',
        nrLike = 0,
        comentarioProdutoResponse = [];

  factory DetailsGuns.fromJson(Map<String, dynamic> json) {
    return DetailsGuns(
      idProduto: json['idproduto'],
      nmProduto: json['nmproduto'],
      descricao: json['descricao'],
      imagem: json['imagem'],
      nrLike: json['nrlike'],
      comentarioProdutoResponse:
          (json['comentarioProdutoResponse'] as List<dynamic>?)
                  ?.map((item) => ComentarioProdutoResponse.fromJson(item))
                  .toList() ??
              [],
    );
  }

  static DetailsGuns fromJsonList(List<dynamic> jsonData) {
    if (jsonData.isEmpty) {
      return DetailsGuns.empty();
    } else {
      return DetailsGuns.fromJson(jsonData.first);
    }
  }
}
