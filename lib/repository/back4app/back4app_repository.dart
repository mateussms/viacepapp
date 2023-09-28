import 'package:viacepapp/model/via_cep_model.dart';

import 'back4app_custon_dio.dart';

class Back4AppRepositoy {
  final _custonDio = Back4AppCustonDio();

  Back4AppRepositoy();

  Future<ViaCepModel> obterCep(String? cep) async {
    var url = "/ViaCep";
    if (cep != null && cep.isNotEmpty) {
      url = "$url?where={\"cep\":\"$cep\"}";
    }
    var result = await _custonDio.dio.get(url);
    return ViaCepModel.fromJson(result.data);
  }

  Future<void> criar(ViaCepModel viaCepModel) async {
    try {
      await _custonDio.dio
          .post("/ViaCep", data: viaCepModel.toJsonEndpoint());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> atualizar(ViaCepModel viaCepModel) async {
    try {
      // ignore: unused_local_variable
      var response = await _custonDio.dio.put(
          "/ViaCep/${viaCepModel.objectId}",
          data: viaCepModel.toJsonEndpoint());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> remover(String objectId) async {
    try {
      // ignore: unused_local_variable
      var response = await _custonDio.dio.delete("/ViaCep/$objectId");
    } catch (e) {
      rethrow;
    }
  }
}