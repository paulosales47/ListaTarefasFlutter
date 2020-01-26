import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

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

                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );

  }

  List<String> _listaTarefas = ["Estudar"];


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
                      title: Text(_listaTarefas[index])
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
