import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class Global {
  static Database? db;

  static _initMenuTable(Database db) async {
    await db.execute('''CREATE TABLE menu(
            id INTEGER PRIMARY KEY,
            name TEXT,
            level INTEGER,
            isMain INTEGER,
            remark TEXT,
            created_at INTEGER,
            updated_at INTEGER,
            thumbnail TEXT,
            inventories TEXT,
            steps Text
            )''');
  }

  static _initIngredientsTable(Database db) async {
    await db.execute('''CREATE TABLE ingredients(
            id INTEGER  PRIMARY KEY,
            name TEXT,
            alias TEXT,
            type INTEGER,
            shelfLife INTEGER,
            recommendStorageWay INTEGER,
            remark TEXT,
            created_at INTEGER,
            updated_at INTEGER
            )''');
  }

  static _initInventoryTable(Database db) async {
    await db.execute('''CREATE TABLE inventory(
            id INTEGER PRIMARY KEY,
            ingredients_id INTEGER,
            storageWay INTEGER,
            storageTime INTEGER,
            created_at INTEGER,
            updated_at INTEGER
            )''');
  }

  static _init() async {
    String databasePath = await getDatabasesPath();
    String path = p.join(databasePath, 'cook.db');
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await _initMenuTable(db);
        await _initIngredientsTable(db);
        await _initInventoryTable(db);
      },
    );
  }

  static init() async {
    await _init();
  }
}
