import 'package:despertar/routes/routes.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.blue
      ),
      child: Stack(children: <Widget>[
        Positioned(
          bottom: 12.0,
          left: 16.0,
          child: Text("Cadastro de Medicamentos",
          style: TextStyle(color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w500)))
      ],), );
  }
  Widget _createDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap}) {
        return ListTile(
          title: Row(children: [
            Icon(icon), 
            Padding(padding: EdgeInsets.only(left: 8.0),
            child: Text(text),)],),
            onTap: onTap,);
    }

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
        _createHeader(),
        _createDrawerItem(
          icon: Icons.add, text: 'Inserir Medicamento',
          onTap: () => Navigator.pushReplacementNamed(context, Routes.insert)),
        Divider(),
        _createDrawerItem(
          icon: Icons.list, text: 'Listar Medicamento', 
          onTap: () => Navigator.pushReplacementNamed(context, Routes.list)),
        _createDrawerItem(
          icon: Icons.list, text: 'Listar Usuario', 
          onTap: () => Navigator.pushReplacementNamed(context, Routes.listUser)),
        _createDrawerItem(
          icon: Icons.add, text: 'Inserir Usuario', 
          onTap: () => Navigator.pushReplacementNamed(context, Routes.insertUser)),
        ListTile(title: Text('0.0.5'), onTap: (){},)
      ],),
    );
  }
  }
