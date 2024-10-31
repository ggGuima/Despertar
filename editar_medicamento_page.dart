import 'package:despertar/connectionFactory/connection_factory.dart';
import 'package:despertar/connectionFactory/medicamento_dao.dart';
import 'package:despertar/model/medicamento.dart';
import 'package:despertar/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';


class EditarMedicamentoPage extends StatefulWidget {
static const String routeName = '/edit';
@override
_EditarMedicamentoState createState() => _EditarMedicamentoState();
}
class _EditarMedicamentoState extends State<EditarMedicamentoPage> {
final _formKey = GlobalKey<FormState>();
final _nomeController = TextEditingController();
final _frequenciaController = TextEditingController();
final _periodoController = TextEditingController();
int _id = 0;
Medicamento? _medicamento;
@override
void dispose() { 
  _nomeController.dispose();
  _frequenciaController.dispose();
  _periodoController.dispose();
  super.dispose();
}
void _obterMedicamento() async { 
 Database? db = await ConnectionFactory.factory.database;
 MedicamentoDAO dao = MedicamentoDAO(db!);
this._medicamento = await dao.obterPorId(this._id);
ConnectionFactory.factory.close();


  _nomeController.text = this._medicamento!.nome;
  _frequenciaController.text = this._medicamento!.frequencia.toString();
  _periodoController.text = this._medicamento!.periodo.toString();
}
void _salvar() async {
    this._medicamento!.nome = _nomeController.text;
    this._medicamento!.frequencia = _frequenciaController.text;
    this._medicamento!.periodo = _periodoController.text;

    Database? db = await ConnectionFactory.factory.database;
    MedicamentoDAO dao = MedicamentoDAO(db!);
    await dao.atualizar(this._medicamento!);
    ConnectionFactory.factory.close();


    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Medicamento editado com sucesso.')));
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
            Text("Frequência:"),
            Expanded(child: TextFormField(controller: _frequenciaController,
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
            Text("Período:"),
            Expanded(child: TextFormField(controller: _periodoController,
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
  _obterMedicamento();
  return new Scaffold(appBar: AppBar(title: Text("Editar Medicamento"),),
  drawer: AppDrawer(),
  body: _buildForm(context),);
 }
}