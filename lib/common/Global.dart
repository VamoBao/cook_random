import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class Global {
  ///菜单数据库实例
  static Database? menuDatabase;

  ///蔬菜数据库实例
  static Database? vegetableDatabase;

  ///库存数据库实例
  static Database? inventoryDatabase;

  ///初始化菜单数据库
  static _menuInit() async {
    var databasePath = await getDatabasesPath();
    String dbPath = p.join(databasePath, 'menu.db');
    await deleteDatabase(dbPath);
    menuDatabase = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE menu(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            level TEXT NOT NULL,
            isMain INTEGER,
            created_at INTEGER,
            updated_at INTEGER
            )''');
      },
    );
  }

  ///初始化蔬菜数据库
  static _vegetableInit() async {
    var databasePath = await getDatabasesPath();
    String dbPath = p.join(databasePath, 'vegetable.db');
    vegetableDatabase = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE vegetable(
            id INTEGER  PRIMARY KEY,
            name TEXT NOT NULL,
            alias TEXT,
            shelfLife INTEGER NOT NULL,
            recommendStorageWay TEXT NOT NULL,
            remark TEXT,
            created_at INTEGER,
            updated_at INTEGER
            )''');
      },
    );
  }

  ///初始化库存数据库
  static _inventoryInit() async {
    var databasePath = await getDatabasesPath();
    String dbPath = p.join(databasePath, 'inventory.db');
    inventoryDatabase = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE inventory(
            id INTEGER PRIMARY KEY,
            vegetable_id INTEGER NOT NULL,
            storageWay TEXT NOT NULL,
            storageTime INTEGER NOT NULL,
            created_at INTEGER,
            updated_at INTEGER
            )''');
      },
    );
  }

  static init() async {
    await _menuInit();
    await _vegetableInit();
    await _inventoryInit();
  }
}
