import 'package:cook_random/common/Global.dart';
import 'package:cook_random/model/Inventory.dart';

class InventoryHelper {
  static getList() async {
    final List<Map<String, Object?>>? res = await Global.db
        ?.rawQuery('''SELECT inventory.*,name AS ingredientName,shelfLife
        FROM inventory
        JOIN ingredients ON inventory.ingredients_id=ingredients.id
        ''');
    return res?.map((e) {
      return Inventory.fromMap(e);
    }).toList();
  }

  ///新增
  static insert(Inventory inventory) async {
    return await Global.db?.insert('inventory', inventory.toMap());
  }

  ///修改
  static update(Inventory inventory) async {
    return await Global.db?.update(
      'inventory',
      inventory.toMap(),
      where: 'id=?',
      whereArgs: [inventory.id],
    );
  }

  ///删除
  static Future<int?> remove(int id) async {
    return await Global.db?.delete('inventory', where: 'id=?', whereArgs: [id]);
  }
}
