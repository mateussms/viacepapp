import 'package:flutter/material.dart';
import 'package:viacepapp/model/via_cep_model.dart';
import 'package:viacepapp/repository/via_cep_repository.dart';

class ViaCepPage extends StatefulWidget {
  const ViaCepPage({super.key});

  @override
  State<ViaCepPage> createState() => _ViaCepPageState();
}

class _ViaCepPageState extends State<ViaCepPage> {
  
  late ViaCepRepository viaCepRepository;
  List<ViaCepModel> viaCepModel = [];

  TextEditingController objectIdController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController logradouroController = TextEditingController();
  TextEditingController complementoController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController localidadeController = TextEditingController();
  TextEditingController ufController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    carregaDados();

    _focusNode.addListener(() async{
        if (!_focusNode.hasFocus && cepController.text.length == 8) {
      
        ViaCepModel viaCep          = await viaCepRepository.readViaCep(cepController.text);
        logradouroController.text   = viaCep.logradouro ?? "";
        complementoController.text  = viaCep.complemento ?? "";
        bairroController.text       = viaCep.bairro ?? "";
        localidadeController.text   = viaCep.localidade ?? "";
        ufController.text           = viaCep.uf ?? "";
        setState(() {});
        
      }
      else  if (!_focusNode.hasFocus && cepController.text.length != 8) {
        showDialog(
          context: context, 
          builder: (_){
          return AlertDialog(
                  title: const Text('Alerta'),
                  content: const Text('Informe o CEP sem mascara.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Fecha o alerta
                      },
                      child: const Text('Fechar'),
                    ),
                  ],
                );
        });
      }
    });
  }

  carregaDados() async{
    viaCepRepository  = await ViaCepRepository.carregar();
   
    viaCepModel     = await viaCepRepository.obterDados();
   
    setState(() {});
  }

  _showModalBottomSheet(String? cep) async{
    if(cep != null){
      ViaCepModel vcm = await viaCepRepository.get(cep);
      objectIdController.text          = vcm.objectId         ?? "";
      cepController.text          = vcm.cep         ?? "";
      logradouroController.text   = vcm.logradouro  ?? "";
      complementoController.text  = vcm.complemento ?? "";
      bairroController.text       = vcm.bairro      ?? "";
      localidadeController.text   = vcm.localidade  ?? "";
      ufController.text           = vcm.uf          ?? "";

    }
    // ignore: use_build_context_synchronously
    showModalBottomSheet<void>(context: context, builder: (_){
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [ Expanded(
                  child: Column(children: [
                    TextField(
                        controller: cepController,
                        decoration: const InputDecoration(
                          labelText: "CEP",
                          icon: Icon(Icons.people)
                        ),
                        keyboardType: TextInputType.number,
                        focusNode: _focusNode,
                    ),
                    TextField(
                        controller: logradouroController,
                        decoration: const InputDecoration(
                          labelText: "Logradouro",
                          icon: Icon(Icons.people)
                        ),
                        keyboardType: TextInputType.number,
                        readOnly: true,
                    ),
                    TextField(
                        controller: complementoController,
                        decoration: const InputDecoration(
                          labelText: "Complemento",
                          icon: Icon(Icons.people)
                        ),
                        keyboardType: TextInputType.text,
                    ),
                    TextField(
                        controller: bairroController,
                        decoration: const InputDecoration(
                          labelText: "Bairro",
                          icon: Icon(Icons.people)
                        ),
                        keyboardType: TextInputType.text,
                        readOnly: true,
                    ),
                    TextField(
                        controller: localidadeController,
                        decoration: const InputDecoration(
                          labelText: "Localidade",
                          icon: Icon(Icons.people)
                        ),
                        keyboardType: TextInputType.text,
                        readOnly: true,
                    ),
                    TextField(
                        controller: ufController,
                        decoration: const InputDecoration(
                          labelText: "UF",
                          icon: Icon(Icons.people)
                        ),
                        keyboardType: TextInputType.text,
                        readOnly: true,
                    ),
                    TextButton(
                      onPressed: () async{
                        if(cepController.text.trim().isEmpty){
                          showDialog(
                            context: context, 
                            builder: (_){
                            return AlertDialog(
                                    title: const Text('Alerta'),
                                    content: const Text('Informe o CEP a ser cadastrado.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Fecha o alerta
                                        },
                                        child: const Text('Fechar'),
                                      ),
                                    ],
                                  );
                          });
                          return;
                        }
                        await viaCepRepository.salvar(objectId: objectIdController.text ,cep:cepController.text, complemento:complementoController.text);
                        objectIdController.text     = "";
                        cepController.text          = "";
                        logradouroController.text   = "";
                        complementoController.text  = "";
                        bairroController.text       = "";
                        localidadeController.text   = "";
                        ufController.text           = "";
                        viaCepModel                 = await viaCepRepository.obterDados();
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        setState(() {});
                      }, 
                      child: const Text("Salvar")
                    
                    ),
              
                ],),
                )
              ]),
            );
          });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //drawer: const CustomDrawer(),
        floatingActionButton: FloatingActionButton(onPressed: (){
          _showModalBottomSheet(null);
        },
        tooltip: "Adicionar IMC", 
        child: const Icon(Icons.add),
        ),
        body: Column(
            children: [
            (viaCepModel.isEmpty) ?
              const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "Sem registros para serem listados",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
            :
              Expanded(
                child: ListView.builder(
                        itemCount: viaCepModel.length,
                        itemBuilder: (_, int index){
                          return 
                              Dismissible(
                                key: Key(UniqueKey().toString()),
                                 background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                onDismissed: (direction) async {
                                  await viaCepRepository.delete(index);
                                  viaCepModel = await viaCepRepository.obterDados();
                                  setState(() {});
                                },
                                
                                  child: Card(
                                    child:  Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        // ignore: sized_box_for_whitespace
                                        children:[Container(
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            
                                                  children: [
                                                  //, ${viaCepModel[index].complemento}, ${viaCepModel[index]} , ${viaCepModel[index].bairro}, 
                                                    Row(
                                                      children: [

                                                        Flexible(
                                                          flex: 5,
                                                          fit: FlexFit.loose,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                "${viaCepModel[index].cep} - ${viaCepModel[index].localidade}, ${viaCepModel[index].uf!.toUpperCase()}",
                                                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                                                              ),
                                                              Text("${viaCepModel[index].logradouro}",
                                                                style: const TextStyle(fontSize: 12)),
                                                              Text("${viaCepModel[index].complemento}", style: const TextStyle(fontSize: 12)),
                                                              Text("${viaCepModel[index].bairro}",
                                                                style: const TextStyle(fontSize: 12)),
                                                            ],
                                                          ),
                                                        ),
                                                        
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,                                                          
                                                          children: [
                                                            InkWell(
                                                              child: const Icon(Icons.edit),
                                                              onTap: () {
                                                                _showModalBottomSheet(viaCepModel[index].cep);
                                                              },
                                                                
                                                            )
                                                          ],
                                                        ),
                                                        
                                                      ],
                                                    ),
                                                   
                                        
                                        
                                                  ],
                                                ),
                                        ),
                                  
                                          ],
                                        )
                                  
                                      ),
                                    ),
                                
                                
                              );
                        
                        },
                      ),
              ),
          ],
        ),
              
      ),
    );
  }
}