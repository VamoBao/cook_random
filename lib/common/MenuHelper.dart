import 'package:cook_random/common/Global.dart';
import 'package:cook_random/model/Menu.dart';

class MenuHelper {
  static getList() async {
    return Global.menuDatabase?.rawQuery('SELECT * FROM menu');
  }

  static insert(Menu menu) async {
    return await Global.menuDatabase?.insert('menu', menu.toMap());
  }
}
