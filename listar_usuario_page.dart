import 'package:despertar/connectionFactory/connection_factory.dart';
import 'package:despertar/connectionFactory/usuario_dao.dart';
import 'package:despertar/model/usuario.dart';
import 'package:despertar/view/editar_usuario_page.dart';
import 'package:despertar/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ListarUsuarioPage extends StatefulWidget {
  static const String routeName = '/listUser';
  @override
  State<StatefulWidget> createState() => _ListarUsuarioPage();
}

class _ListarUsuarioPage extends State<ListarUsuarioPage> {
  List<Usuario> _lista = <Usuario>[];

  @override
  void initState() {
    super.initState();
    _refreshList();
  }
  @override
  void dispose() {
    super.dispose();}
  void _refreshList() async {
    List<Usuario> tempList = await _obterTodos();
    setState(() {
    _lista = tempList;  
    });
  }
  Future<List<Usuario>> _obterTodos() async{
    Database db = await ConnectionFactory.factory.database;
    UsuarioDAO dao = UsuarioDAO(db!);

    List<Usuario> tempLista = await dao.obterTodos();

    ConnectionFactory.factory.close();

    return tempLista;
  }
  void _removerUsuario(int id) async {
    Database? db = await ConnectionFactory.factory.database;
    UsuarioDAO dao = UsuarioDAO(db!);

    await dao.remover(id);

    ConnectionFactory.factory.close();
  }
  void _showItem(BuildContext context, int index){
    Usuario usuario = _lista[index];

    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text(usuario.nome),
        content: Column(
          children: [
            Text("Nome: ${usuario.nome}"),
            Text("idade: ${usuario.idade}"),
            Text("sexo: ${usuario.sexo}"),
            ],),
            actions: [
              TextButton(child: Text("OK"), onPressed:() {
                Navigator.of(context).pop();
              })
            ]);
    });
  }
  void _editItem(BuildContext context, int index){
    Usuario u = _lista[index];

    Navigator.pushNamed(context, EditarUsuarioPage.routeName,
    arguments: <String, int>{
      "id": u.id!
    },);
  }
  void _removeItem(BuildContext context, int index) {
      Usuario u = _lista[index];
      showDialog(context: context, builder: (BuildContext context) => AlertDialog(
        title: Text("Remover Usuário"),
        content: Text("Gostaria realmente de remover ${u.nome}?"),
        actions: [
          TextButton(onPressed: (){
            _refreshList();
            Navigator.of(context).pop();
          }, child: Text("Não")),
          TextButton(onPressed: (){
            _removerUsuario(u.id!);
            _refreshList();
            Navigator.of(context).pop();
          }, child: Text("Sim"))
        ],
      ));
  }
  ListTile _buildItem(BuildContext context, int index){
    Usuario u = _lista[index];
    return ListTile(
      title: Text(u.nome),
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
      appBar: AppBar(title: Text("Listagem de Usuários"),),
      drawer: AppDrawer(),
      body: ListView.builder(itemCount: _lista.length,
      itemBuilder: _buildItem,));
  }
  }
  
