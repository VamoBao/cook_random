import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class Global {
  ///菜单数据库实例
  static Database? menuDatabase;

  ///库存数据库实例
  static Database? inventoryDatabase;

  ///食材数据库实例
  static Database? ingredientsDatabase;

  ///初始化菜单数据库
  static _menuInit() async {
    var databasePath = await getDatabasesPath();
    String dbPath = p.join(databasePath, 'menu.db');
    menuDatabase = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE menu(
            id INTEGER PRIMARY KEY,
            name TEXT,
            level INTEGER,
            isMain INTEGER,
            remark TEXT,
            created_at INTEGER,
            updated_at INTEGER
            )''');
      },
    );
  }

  ///初始化食材数据库
  static _ingredientsInit() async {
    var databasePath = await getDatabasesPath();
    // String dbvPath = p.join(databasePath, 'vegetable.db');
    // await deleteDatabase(dbvPath);
    String dbPath = p.join(databasePath, 'ingredients.db');
    ingredientsDatabase = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
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
            ingredients_id INTEGER,
            storageWay INTEGER,
            storageTime INTEGER,
            created_at INTEGER,
            updated_at INTEGER
            )''');
      },
    );
  }

  static init() async {
    await _menuInit();
    await _ingredientsInit();
    await _inventoryInit();
  }
}
