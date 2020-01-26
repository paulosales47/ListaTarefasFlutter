import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _listaTarefas = [];

  _adicionarTarefa(BuildContext context){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Adicionar Tarefa"),
          content: TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Informe sua tarefa",
            ),
            onChanged: (text){

            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("Salvar"),
              onPressed: (){
                _salvarArquivo();
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );

  }

  Future<File> _recuperarDiretorio() async{
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/tarefas.json");
  }

  _salvarArquivo() async {

    var arquivo = await _recuperarDiretorio();

    //CRIAR TAREFAS
    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = "Estudar";
    tarefa["realizada"] = false;
    _listaTarefas.add(tarefa);

    String dados = jsonEncode(_listaTarefas);
    arquivo.writeAsString(dados);
  }

  Future<String> _lerArquivo() async{
    try{

      final arquivo = await _recuperarDiretorio();
      return arquivo.readAsString();


    }catch(e){
      return null;
    }

  }

  @override
  void initState() {
    super.initState();
    _lerArquivo().then((dados){
      _listaTarefas = jsonDecode(dados);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Lista de Tarefas"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _listaTarefas.length,
                itemBuilder: (context, index){
                  return ListTile(
                      title: Text(_listaTarefas[index]["titulo"])
                  );
                }
              ),

            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _adicionarTarefa(context),
          backgroundColor: Colors.purple,
          child: Icon(Icons.add),
      ),
    );
  }
}
