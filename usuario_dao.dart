import 'package:despertar/model/usuario.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioDAO {
  Database database;

  UsuarioDAO(this.database);

  Future<void> inserir(Usuario usuario) async {
    await database.insert(
      "tb_usuario", 
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
     );
  }
  Future<List<Usuario>> obterTodos() async {
    
    final List<Map<String, dynamic>> maps = 
                                            await database.query("tb_usuario");
    return Usuario.fromMaps(maps);
  }
  Future<Usuario?> obterPorId(int id) async {
    final List<Map<String, dynamic>> maps = 
    await database.query(
          "tb_usuario",
          where: "Usuario_id = ?",
          whereArgs: [id]);
    if (maps.length > 0) {
      return Usuario.fromMap(maps.first);
    }
    return null;
  }
  Future<void> atualizar(Usuario usuario) async {
    print("String atualizar");
    print(usuario.id);
    await database.update(
      'tb_usuario',
      usuario.toMap(),
      where: "Usuario_id = ?",
      whereArgs: [usuario.id],
      );
  }
  Future<void> remover(int id) async {
    await database.delete(
      'tb_usuario',
      where: "Usuario_id = ?",
      whereArgs: [id]
      );
  }
}