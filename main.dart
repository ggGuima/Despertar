import 'package:despertar/connectionFactory/connection_factory.dart';
import 'package:despertar/routes/routes.dart';
import 'package:despertar/view/editar_medicamento_page.dart';
import 'package:despertar/view/editar_usuario_page.dart';
import 'package:despertar/view/inserir_medicamento_page.dart';
import 'package:despertar/view/inserir_usuario_page.dart';
import 'package:despertar/view/listar_medicamento_page.dart';
import 'package:despertar/view/listar_usuario_page.dart';
import 'package:despertar/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


Future main() async { 
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;


  runApp(MyApp());
  }
  
class TextoWidget extends StatelessWidget{
  final String texto;
  const TextoWidget(this.texto);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5)),
    
    child: Text(texto, style: TextStyle(fontSize: 28)));
  }
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
      return MaterialApp(
        title: 'Despertar',
        theme: ThemeData(primarySwatch: Colors.blue,),
      
      home: MyHomePage(title: 'Despertar'),
      routes: {
        Routes.edit: (context) => EditarMedicamentoPage(),
        Routes.insert: (context) => InserirMedicamentoPage(),
        Routes.list: (context) => ListarMedicamentoPage(),
        Routes.listUser: (context) => ListarUsuarioPage(),
        Routes.editUser: (context) => EditarUsuarioPage(),
        Routes.insertUser: (context) => InserirUsuarioPage(),
      },
  );}
  
  }


class MyHomePage extends StatefulWidget {
   MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      drawer: AppDrawer(),
    );
  }
  }

