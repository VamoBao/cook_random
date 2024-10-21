import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class Global {
  static Database? menuDatabase;

  static init() async {
    var databasePath = await getDatabasesPath();
    String dbPath = p.join(databasePath,'menu.db');
     menuDatabase = await openDatabase(dbPath,version: 1,
      onCreate: (Database db,int version) async {
      await db.execute(
        'CREATE TABLE Menu (id INTEGER PRIMARY KEY,name TEXT)'
      );
      }
    );
  }
  
  static Future<List<Map<String, Object?>>?> getList() async {
    var res = await menuDatabase?.rawQuery('SELECT * FROM Menu');
    return res;
  }
}