import 'package:cook_random/common/Global.dart';
import 'package:cook_random/model/Menu.dart';

class MenuHelper {
  ///获取菜单列表
  static getList() async {
    final List<Map<String, Object?>>? res =
        await Global.db?.rawQuery('SELECT * FROM menu');
    return res?.map((e) {
      return Menu.fromMap(e);
    }).toList();
  }

  static Future<Menu?> getById(int id) async {
    final List<Map<String, Object?>>? res =
        await Global.db?.rawQuery('SELECT * FROM menu WHERE id=$id');
    if (res?.length != 0) {
      return Menu.fromMap(res![0]);
    }
    return null;
  }

  /// 搜索
  static getSearchList(String keyword) async {
    final res = await Global.db
        ?.rawQuery('SELECT * FROM menu WHERE name LIKE "%$keyword%"');
    return res?.map((e) {
      return Menu.fromMap(e);
    }).toList();
  }

  static getFilterList(List<MenuLevel> level) async {
    String levelSQL = level.map((l) => l.index).toList().join(',');
    final res = await Global.db?.rawQuery('''SELECT * FROM menu
    WHERE level IN ($levelSQL)''');
    return res?.map((e) {
      return Menu.fromMap(e);
    }).toList();
  }

  ///新增菜单
  static insert(Menu menu) async {
    return await Global.db?.insert('menu', menu.toMap());
  }

  ///修改菜单
  static update(Menu menu) async {
    return await Global.db?.update(
      'menu',
      menu.toMap(),
      where: 'id=?',
      whereArgs: [menu.id],
    );
  }

  ///删除菜单
  static Future<int?> remove(int id) async {
    return await Global.db?.delete('menu', where: 'id=?', whereArgs: [id]);
  }
}
