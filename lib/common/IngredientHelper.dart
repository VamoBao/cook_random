import 'package:cook_random/model/Ingredient.dart';

import 'Global.dart';

class IngredientHelper {
  static getList() async {
    final List<Map<String, Object?>>? res =
        await Global.db?.rawQuery('SELECT * FROM ingredients');
    return res?.map((e) {
      return Ingredient.fromMap(e);
    }).toList();
  }

  ///新增
  static insert(Ingredient ingredient) async {
    return await Global.db?.insert('ingredients', ingredient.toMap());
  }

  ///修改
  static update(Ingredient ingredient) async {
    return await Global.db?.update(
      'ingredients',
      ingredient.toMap(),
      where: 'id=?',
      whereArgs: [ingredient.id],
    );
  }

  ///删除
  static Future<int?> remove(int id) async {
    return await Global.db
        ?.delete('ingredients', where: 'id=?', whereArgs: [id]);
  }
}
