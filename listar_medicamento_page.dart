import 'package:despertar/connectionFactory/connection_factory.dart';
import 'package:despertar/connectionFactory/medicamento_dao.dart';
import 'package:despertar/model/medicamento.dart';
import 'package:despertar/view/editar_medicamento_page.dart';
import 'package:despertar/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ListarMedicamentoPage extends StatefulWidget {
  static const String routeName = '/list';
  @override
  State<StatefulWidget> createState() => _ListarMedicamentoPage();
}

class _ListarMedicamentoPage extends State<ListarMedicamentoPage> {
  List<Medicamento> _lista = <Medicamento>[];

  @override
  void initState() {
    super.initState();
    _refreshList();
  }
  @override
  void dispose() {
    super.dispose();}
  void _refreshList() async {
    List<Medicamento> tempList = await _obterTodos();
    setState(() {
    _lista = tempList;  
    });
  }
  Future<List<Medicamento>> _obterTodos() async{
    Database db = await ConnectionFactory.factory.database;
    MedicamentoDAO dao = MedicamentoDAO(db!);

    List<Medicamento> tempLista = await dao.obterTodos();

    ConnectionFactory.factory.close();

    return tempLista;
  }
  void _removerMedicamento(int id) async {
    Database? db = await ConnectionFactory.factory.database;
    MedicamentoDAO dao = MedicamentoDAO(db!);

    await dao.remover(id);

    ConnectionFactory.factory.close();
  }
  void _showItem(BuildContext context, int index){
    Medicamento medicamento = _lista[index];

    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text(medicamento.nome),
        content: Column(
          children: [
            Text("Nome: ${medicamento.nome}"),
            Text("Frequência: ${medicamento.frequencia}"),
            Text("Período: ${medicamento.periodo}"),
            ],),
            actions: [
              TextButton(child: Text("OK"), onPressed:() {
                Navigator.of(context).pop();
              })
            ]);
    });
  }
  void _editItem(BuildContext context, int index){
    Medicamento m = _lista[index];

    Navigator.pushNamed(context, EditarMedicamentoPage.routeName,
    arguments: <String, int>{
      "id": m.id!
    },);
  }
  void _removeItem(BuildContext context, int index) {
      Medicamento m = _lista[index];
      showDialog(context: context, builder: (BuildContext context) => AlertDialog(
        title: Text("Remover Medicamento"),
        content: Text("Gostaria realmente de remover ${m.nome}?"),
        actions: [
          TextButton(onPressed: (){
            _refreshList();
            Navigator.of(context).pop();
          }, child: Text("Não")),
          TextButton(onPressed: (){
            _removerMedicamento(m.id!);
            _refreshList();
            Navigator.of(context).pop();
          }, child: Text("Sim"))
        ],
      ));
  }
  ListTile _buildItem(BuildContext context, int index){
    Medicamento m = _lista[index];
    return ListTile(
      title: Text(m.nome),
      onTap: (){_showItem(context, index);},
      trailing: PopupMenuButton(
        itemBuilder: (context){
          return [
          PopupMenuItem(value: 'edit', child: Text("Editar")),
          PopupMenuItem(value: 'delete', child: Text("Remover")),
          ];
      },
      onSelected: (String value){
        if(value == 'edit')
        _editItem(context, index);
        else
          _removeItem(context, index);
      },
      ),
    );
  }
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: AppBar(title: Text("Listagem de Medicamentos"),),
      drawer: AppDrawer(),
      body: ListView.builder(itemCount: _lista.length,
      itemBuilder: _buildItem,));
  }
  }
  
