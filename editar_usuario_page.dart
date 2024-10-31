import 'package:despertar/connectionFactory/connection_factory.dart';
import 'package:despertar/connectionFactory/usuario_dao.dart';
import 'package:despertar/model/usuario.dart';
import 'package:despertar/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';


class EditarUsuarioPage extends StatefulWidget {
static const String routeName = '/editUser';
@override
_EditarUsuarioState createState() => _EditarUsuarioState();
}
class _EditarUsuarioState extends State<EditarUsuarioPage> {
final _formKey = GlobalKey<FormState>();
final _nomeController = TextEditingController();
final _idadeController = TextEditingController();
final _sexoController = TextEditingController();
int _id = 0;
Usuario? _usuario;
@override
void dispose() { 
  _nomeController.dispose();
  _idadeController.dispose();
  _sexoController.dispose();
  super.dispose();
}
void _obterUsuario() async { 
 Database? db = await ConnectionFactory.factory.database;
 UsuarioDAO dao = UsuarioDAO(db!);
this._usuario = await dao.obterPorId(this._id);
ConnectionFactory.factory.close();


  _nomeController.text = this._usuario!.nome;
  _idadeController.text = this._usuario!.idade.toString();
  _sexoController.text = this._usuario!.sexo.toString();
}
void _salvar() async {
    this._usuario!.nome = _nomeController.text;
    this._usuario!.idade = _idadeController.text;
    this._usuario!.sexo = _sexoController.text;

    Database? db = await ConnectionFactory.factory.database;
    UsuarioDAO dao = UsuarioDAO(db!);
    await dao.atualizar(this._usuario!);
    ConnectionFactory.factory.close();


    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário editado com sucesso.')));
    }
Widget _buildForm(BuildContext context) {
  return Column(
    children: [
      Form(key: _formKey,
      child: ListView(shrinkWrap: true, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Nome:"),
            Expanded(child: TextFormField(controller: _nomeController,
            validator: (value){if(value!.isEmpty){return 'Campo não pode ser vazio';}
            return null;},))
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("idade:"),
            Expanded(child: TextFormField(controller: _idadeController,
            validator: (value){
              if(value!.isEmpty){
                return 'Campo não pode ser vazio';
              }
              return null;
            },))
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Sexo:"),
            Expanded(child: TextFormField(controller: _sexoController,
            validator: (value){
              if(value!.isEmpty){
                return 'Campo não pode ser vazio';
              }
              return null;
            },))
          ],
        ),
        Row(
          children: [
            ElevatedButton(onPressed: (){if (_formKey.currentState!.validate()){
            _salvar();
          }},
          child: Text('Salvar'),),
          ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancelar'),),
      ])
      ],),)
    ],
  );
}
@override
Widget build(BuildContext context) {
  final Map m = ModalRoute.of(context)!.settings.arguments as Map;
  this._id = m["id"];
  _obterUsuario();
  return new Scaffold(appBar: AppBar(title: Text("Editar Usuário"),),
  drawer: AppDrawer(),
  body: _buildForm(context),);
 }
}