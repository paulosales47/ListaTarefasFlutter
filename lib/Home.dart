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
  var controllerTarefa = TextEditingController();

  _adicionarTarefa(BuildContext context){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Adicionar Tarefa"),
          content: TextField(
            keyboardType: TextInputType.text,
            controller: controllerTarefa,
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
                setState(() {
                  _salvarTarefa();
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      }
    );

  }

  _salvarTarefa() async{

    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = controllerTarefa.text;
    tarefa["realizada"] = false;
    _listaTarefas.add(tarefa);
    await _salvarArquivo();
    controllerTarefa.text = "";
  }

  Future<File> _recuperarDiretorio() async{
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/tarefas.json");
  }

  _salvarArquivo() async {

    var arquivo = await _recuperarDiretorio();
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

  Dismissible _montarListaTarefas(BuildContext context, int index){

    return Dismissible(
      direction: DismissDirection.horizontal,
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Icon(Icons.delete, color: Colors.white,)
          ],
        ),

      ),
      secondaryBackground: Container(
          color: Colors.blue,
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
            Icon(Icons.done, color: Colors.white,)
        ],
      ),
      ),
      key: UniqueKey(),
      onDismissed: (direcao){
        if(direcao == DismissDirection.startToEnd){
          setState(() {
            _listaTarefas.removeAt(index);
            _salvarArquivo();
          });
        }
        else if(direcao == DismissDirection.endToStart){
          setState(() {
            _listaTarefas[index]["realizada"] = true;
            _salvarArquivo();
          });
        }

      },
      child: CheckboxListTile(
        title: Text(_listaTarefas[index]["titulo"]),
        value: _listaTarefas[index]["realizada"],
        onChanged: (valor){
          setState(() {
            _listaTarefas[index]["realizada"] = valor;
            _salvarArquivo();
          });
        },
      ),
    );
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
                    return _montarListaTarefas(context, index);
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
