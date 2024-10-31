import 'package:despertar/connectionFactory/connection_factory.dart';
import 'package:despertar/connectionFactory/medicamento_dao.dart';
import 'package:despertar/main.dart';
import 'package:despertar/model/medicamento.dart';
import 'package:despertar/widgets/drawer.dart';
import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart';

class InserirMedicamentoPage extends StatefulWidget {
  static const String routeName = '/insert';
  @override
  _InserirMedicamentoState createState() => _InserirMedicamentoState();
}

class _InserirMedicamentoState extends State<InserirMedicamentoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _frequenciaController = TextEditingController();
  final _periodoController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _frequenciaController.dispose();
    _periodoController.dispose();
    super.dispose();
  }

  void _salvar() async {
    Database? db = await ConnectionFactory.factory.database;
    MedicamentoDAO dao = MedicamentoDAO(db!);
    Medicamento medicamento = Medicamento.novo(_nomeController.text, _frequenciaController.text, _periodoController.text);

    await dao.inserir(medicamento);

    ConnectionFactory.factory.close();

    _nomeController.clear();
    _periodoController.clear();
    _frequenciaController.clear();
    
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Medicamento salvo com sucesso.')));
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
              TextoWidget("Frequência:"),
              Expanded(
                  child: TextFormField(
                controller: _frequenciaController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo não pode ser vazio';
                  }
                  return null;
                },
              ))
            ]),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              TextoWidget("Período:"),
              Expanded(
                  child: TextFormField(
                controller: _periodoController,
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
        title: Text("Inserir Medicamento"),
      ),
      drawer: AppDrawer(),
      body: _buildForm(context),
    );
  }
}
