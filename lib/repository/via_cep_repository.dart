import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:viacepapp/model/via_cep_model.dart';
import 'package:viacepapp/repository/back4app/back4app_repository.dart';

class ViaCepRepository{

  
  late List<ViaCepModel> viaCepModels = [];
  static late ViaCepModel viaCepModel;
  static List<String> data = [];
  final dio = Dio();

  ViaCepRepository._criar();

  static Future<ViaCepRepository> carregar() async{
    return ViaCepRepository._criar();
  }

  Future<ViaCepModel> get(String cep) async {
    ViaCepModel vcm = await Back4AppRepositoy().obterCep(cep);
    // ignore: unnecessary_null_comparison
    if(vcm == null) {
      return viaCepModels.where((element) => element.cep == cep).first;
    }
    return vcm.ceps.first;
  }

  Future<ViaCepModel> readViaCep(String cep) async {
     ViaCepModel vcm = await Back4AppRepositoy().obterCep(cep);
    // ignore: unnecessary_null_comparison
    if(vcm.ceps.isEmpty) {
      final response = await dio.get("http://viacep.com.br/ws/$cep/json/");
      if(response.statusCode == 200 && response.data != null){
        return ViaCepModel.fromJson(json.decode("$response"));
      }
    }
    
    return vcm.ceps.first;
  }

  Future<void> salvar({required String objectId, required String cep, required String complemento}) async {
    final response = await dio.get("http://viacep.com.br/ws/$cep/json/");
    if(response.statusCode == 200 && response.data["cep"].isNotEmpty){
      var vcm = ViaCepModel.fromJson(json.decode("$response"));
      vcm.complemento = complemento;
      if(objectId.isEmpty){
        viaCepModels.add(vcm);
        await Back4AppRepositoy().criar(vcm);
      }
      else{
        vcm.objectId = objectId;
        await Back4AppRepositoy().atualizar(vcm);
      }
    }
    
    
  }

   Future<void> delete(int index) async {
    try{
      await  Back4AppRepositoy().remover(viaCepModels[index].objectId.toString());
      viaCepModels.removeAt(index);
    // ignore: empty_catches
    } catch(e){
    }
    
  }

  Future<List<ViaCepModel>> obterDados({String? cep}) async {
    viaCepModels = (await  Back4AppRepositoy().obterCep(cep)).ceps;
    return viaCepModels;
  }

}