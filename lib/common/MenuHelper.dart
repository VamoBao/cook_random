import 'package:cook_random/common/Global.dart';
import 'package:cook_random/model/Menu.dart';

class MenuHelper {
  static getList() async {
    final List<Map<String, Object?>>? res =
        await Global.menuDatabase?.rawQuery('SELECT * FROM menu');
    return res?.map((e) {
      return Menu.fromMap(e);
    }).toList();
  }

  static insert(Menu menu) async {
    print(menu.toMap());
    return await Global.menuDatabase?.insert('menu', menu.toMap());
  }
}
