import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

class DatabaseCreator {
  static const itemTable = 'items';
  static const id = 'id';
  static const nome = 'nome';
  static const tipo = 'tipo';
  static const selec = 'selec';
  static const oculto = 'oculto';

  static void databaseLog(String functionName, String sql,
      [List<Map<String, dynamic>> selectQueryResult,
      int insertAndUpdateQueryResult,
      List<dynamic> params]) {
    /*
    print(functionName);
    print(sql);
    if (params != null) {
      print(params);
    }
    if (selectQueryResult != null) {
      print(selectQueryResult);
    } else if (insertAndUpdateQueryResult != null) {
      print(insertAndUpdateQueryResult);
    }*/
  }

  Future<void> createItemsTable(Database db) async {
    final createSql = '''CREATE TABLE IF NOT EXISTS $itemTable 
    ( 
      $id INTEGER PRIMARY KEY, 
      $nome TEXT, 
      $tipo INTEGER,
      $selec BIT NOT NULL,
      $oculto BIT NOT NULL 
    )''';

    await db.execute(createSql);
  }

  Future<String> getDatabasePath(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    //verificar se ja existe
    if (await Directory(dirname(path)).exists()) {
      //await deleteDatabase(path);
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }

    return path;
  }

  Future<void> initDatabase() async {
    final path = await getDatabasePath('items');
    db = await openDatabase(path, version: 1, onCreate: onCreate);
    print(db);
  }

  Future<void> onCreate(Database db, int version) async {
    await createItemsTable(db);
  }
}
