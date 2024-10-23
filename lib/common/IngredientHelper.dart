import 'package:cook_random/model/Ingredient.dart';

import 'Global.dart';

class IngredientHelper {
  static getList() async {
    final List<Map<String, Object?>>? res =
        await Global.ingredientsDatabase?.rawQuery('SELECT * FROM menu');
    return res?.map((e) {
      return Ingredient.fromMap(e);
    }).toList();
  }
}
