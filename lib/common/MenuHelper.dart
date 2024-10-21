import 'package:cook_random/common/Global.dart';

class MenuHelper {
  static getList() async {
    return Global.menuDatabase?.rawQuery('SELECT * FROM menu');
  }
}
