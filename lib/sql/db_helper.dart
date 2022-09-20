import 'dart:async';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.getInstance();
  DatabaseHelper.getInstance();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await _initDb();
      return _db;
    }
  }

  Future _initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'CARTEIRA.db');
    print('db $path');

    var db = await openDatabase(path,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  Future _onCreate(Database db, int newVersion) async {
    String s = await rootBundle.loadString('assets/CREATE.sql');

    List<String> sqls = s.split(';');

    for (String sql in sqls) {
      if (sql.trim().isNotEmpty) {
        print('sql: $sql');
        await db.execute(sql);
      }
    }
  }
}

Future<FutureOr<void>> _onUpgrade(
    Database db, int oldVersion, int newVersion) async {
  print("_onUpgrade: oldVersion: $oldVersion > newVersion: $newVersion");

  if (oldVersion == 1 && newVersion == 2) {
    await db.execute('ALTER TABLE product ADD COLUMN newer TEXT');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
