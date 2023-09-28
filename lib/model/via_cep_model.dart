class ViaCepModel {
  String? objectId = "";
  String? cep;
  String? logradouro;
  String? complemento;
  String? bairro;
  String? localidade;
  String? uf;
  String? ibge;
  String? gia;
  String? ddd;
  String? siafi;

  List<ViaCepModel> ceps = [];

  ViaCepModel(
      {this.objectId,
      this.cep,
      this.logradouro,
      this.complemento,
      this.bairro,
      this.localidade,
      this.uf,
      this.ibge,
      this.gia,
      this.ddd,
      this.siafi});

  ViaCepModel.fromJson(Map<String, dynamic> json) {
     if (json['results'] != null) {
      ceps = <ViaCepModel>[];
      json['results'].forEach((v) {
        ceps.add(ViaCepModel.fromJson(v));
      });
    }
    else {
      objectId = json['objectId'] ;
      cep = json['cep'] ?? "";
      logradouro = json['logradouro'] ?? "";
      complemento = json['complemento'] ?? "";
      bairro = json['bairro'] ?? "";
      localidade = json['localidade'] ?? "";
      uf = json['uf'] ?? "";
      ibge = json['ibge'] ?? "";
      gia = json['gia'] ?? "";
      ddd = json['ddd'] ?? "";
      siafi = json['siafi'] ?? "";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['cep'] = cep;
    data['logradouro'] = logradouro;
    data['complemento'] = complemento;
    data['bairro'] = bairro;
    data['localidade'] = localidade;
    data['uf'] = uf;
    data['ibge'] = ibge;
    data['gia'] = gia;
    data['ddd'] = ddd;
    data['siafi'] = siafi;
    return data;
  }

   Map<String, dynamic> toJsonEndpoint() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cep'] = cep;
    data['logradouro'] = logradouro;
    data['complemento'] = complemento;
    data['bairro'] = bairro;
    data['localidade'] = localidade;
    data['uf'] = uf;
    return data;
  }
}
