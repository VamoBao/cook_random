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
    menuDatabase = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE menu(
            id BIGINT AUTO_INCREMENT PRIMARY KEY,
            name VARCHAR(255) NOT NULL,
            level VARCHAR(10) NOT NULL,
            isMain BOOLEAN,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
            id BIGINT AUTO_INCREMENT PRIMARY KEY,
            name VARCHAR(255) NOT NULL,
            alias VARCHAR(255),
            shelfLife INT NOT NULL,
            recommendStorageWay VARCHAR(20) NOT NULL,
            remark VARCHAR(255),
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
            id BIGINT AUTO_INCREMENT PRIMARY KEY,
            vegetable_id BIGINT NOT NULL,
            storageWay VARCHAR(20) NOT NULL,
            storageTime TIMESTAMP NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
