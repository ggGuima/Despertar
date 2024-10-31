import 'package:despertar/connectionFactory/connection_factory.dart';
import 'package:despertar/connectionFactory/usuario_dao.dart';
import 'package:despertar/main.dart';
import 'package:despertar/model/usuario.dart';
import 'package:despertar/widgets/drawer.dart';
import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart';

class InserirUsuarioPage extends StatefulWidget {
  static const String routeName = '/insertUser';
  @override
  _InserirUsuarioState createState() => _InserirUsuarioState();
}

class _InserirUsuarioState extends State<InserirUsuarioPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _sexoController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _sexoController.dispose();
    super.dispose();
  }

  void _salvar() async {
    Database? db = await ConnectionFactory.factory.database;
    UsuarioDAO dao = UsuarioDAO(db!);
    Usuario usuario = Usuario.novo(_nomeController.text, _idadeController.text, _sexoController.text);

    await dao.inserir(usuario);

    ConnectionFactory.factory.close();

    _nomeController.clear();
    _idadeController.clear();
    _sexoController.clear();
    
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário salvo com sucesso.')));
  }

  Widget _buildForm(BuildContext context) {
    return Column(children: [
      Form(
          key: _formKey,
          child: ListView(shrinkWrap: true, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              TextoWidget("Nome:"),
              Expanded(
                  child: TextFormField(
                controller: _nomeController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo não pode ser vazio';
                  }
                  return null;
                },
              ))
            ]),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              TextoWidget("Idade:"),
              Expanded(
                  child: TextFormField(
                controller: _idadeController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo não pode ser vazio';
                  }
                  return null;
                },
              ))
            ]),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              TextoWidget("Sexo:"),
              Expanded(
                  child: TextFormField(
                controller: _sexoController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo não pode ser vazio';
                  }
                  return null;
                },
              ))
            ]),
            Row(children: [
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _salvar();
                  }
                },
                child: Text('Salvar'),
              ),
            ])
          ]))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Inserir Usuário"),
      ),
      drawer: AppDrawer(),
      body: _buildForm(context),
    );
  }
}
