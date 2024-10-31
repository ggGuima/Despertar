import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

class ConnectionFactory {
  final int _version = 1;
  final String _databaseFile = "database.db";

  ConnectionFactory._();
  static final ConnectionFactory factory = ConnectionFactory._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await openDatabase(
      join(await getDatabasesPath(), _databaseFile),
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
      version: _version,
    );
    return _database!;
  }

  Future<void> _createDatabase(Database db, int version) async {
   
    await db.execute("PRAGMA foreign_keys = ON");

  
    await db.execute('''
      CREATE TABLE tb_usuario (
        Usuario_id INTEGER PRIMARY KEY AUTOINCREMENT,
        Usuario_nome TEXT NOT NULL,
        Usuario_idade INTEGER,
        Usuario_sexo TEXT
      )
    ''');


    await db.execute('''
      CREATE TABLE tb_medicamento (
        Medicamento_id INTEGER PRIMARY KEY AUTOINCREMENT,
        Medicamento_nome TEXT,
        Medicamento_Frequencia TEXT,
        Medicamento_periodo TEXT,
        Usuario_id INTEGER,
        FOREIGN KEY (Usuario_id) REFERENCES tb_usuario(Usuario_id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {

    await db.execute("DROP TABLE IF EXISTS tb_medicamento");
    await db.execute("DROP TABLE IF EXISTS tb_usuario");
    await _createDatabase(db, _version);
  }

Future<void> deleteDatabase() async {
  
  String path = join(await getDatabasesPath(), _databaseFile);
  
  await databaseFactory.deleteDatabase(path);
}

  void close() {
    if (_database != null) {
      _database!.close();
      _database = null;
    }
  }
}