import 'package:fixlock_app/constants/controllers.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

import '../../utils/http_service.dart';
import 'db_table.dart';

class DB {
  // Construtor com acesso privado
  DB._();
  // Criar uma instancia de DB
  static final DB instance = DB._();
  //Instancia do SQLite
  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'fixlock_app.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, versao) async {
    var dbTable = DBTable();
    await db.execute(dbTable.dipositivo);
    await db.execute(dbTable.dispositivoRegistro);
    await db.execute(dbTable.regiao);
    await db.execute(dbTable.condominio);
  }


}