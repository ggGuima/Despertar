import 'package:despertar/model/medicamento.dart';
import 'package:sqflite/sqflite.dart';

class MedicamentoDAO {
  Database database;

  MedicamentoDAO(this.database);

  Future<void> inserir(Medicamento medicamento) async {
    await database.insert(
      "tb_medicamento", 
      medicamento.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
     );
  }
  Future<List<Medicamento>> obterTodos() async {
    
    final List<Map<String, dynamic>> maps = 
                                            await database.query("tb_medicamento");
    return Medicamento.fromMaps(maps);
  }
  Future<Medicamento?> obterPorId(int id) async {
    final List<Map<String, dynamic>> maps = 
    await database.query(
          "tb_medicamento",
          where: "Medicamento_id = ?",
          whereArgs: [id]);
    if (maps.length > 0) {
      return Medicamento.fromMap(maps.first);
    }
    return null;
  }
  Future<void> atualizar(Medicamento medicamento) async {
    print("String atualizar");
    print(medicamento.id);
    await database.update(
      'tb_medicamento',
      medicamento.toMap(),
      where: "Medicamento_id = ?",
      whereArgs: [medicamento.id],
      );
  }
  Future<void> remover(int id) async {
    await database.delete(
      'tb_medicamento',
      where: "Medicamento_id = ?",
      whereArgs: [id]
      );
  }
}