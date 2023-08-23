import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Db {
  static Database? _database;
  static const String tableIMC = 'imc_history';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'imc_history.db');

    return openDatabase(dbPath, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableIMC (
        id INTEGER PRIMARY KEY,
        item TEXT
      )
    ''');
  }

  Future<int> insertIMC(String item) async {
    final db = await database;
    return db.insert(tableIMC, {'item': item});
  }

  Future<List<Map<String, dynamic>>> getIMCList() async {
    final db = await database;
    return db.query(tableIMC);
  }
}
