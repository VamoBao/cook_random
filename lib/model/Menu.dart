import 'dart:convert';

/// 菜谱类型
enum MenuType {
  /// 主菜
  main('主菜'),

  /// 配菜
  sideDish('配菜'),

  /// 汤菜
  soup('汤菜'),

  /// 甜品
  dessert('甜品'),

  /// 小吃
  snack('小吃');

  final String label;

  const MenuType(this.label);
}

enum MenuLevel {
  /// 简单
  easy('简单'),

  /// 普通
  normal('普通'),

  /// 耗时
  difficult('耗时'),

  /// 很难
  extreme('非常困难');

  final String label;

  const MenuLevel(this.label);
}

class MenuMaterial {
  late String name;
  late String unit;

  MenuMaterial({required this.name, this.unit = ""});

  Map<String, String> toMap() {
    return {"name": name, "unit": unit};
  }

  factory MenuMaterial.fromMap(Map<String, dynamic> map) {
    return MenuMaterial(name: map['name'] ?? '', unit: map['unit'] ?? '');
  }
}

class Menu {
  int? id;
  late String name;
  late MenuLevel level;
  int? createdAt;
  int? updatedAt;
  String? remark;
  String? thumbnail;
  List<String>? steps;
  List<MenuMaterial>? materials;
  MenuType type;

  Menu({
    required this.name,
    required this.level,
    required this.type,
    this.createdAt,
    this.updatedAt,
    this.id,
    this.remark,
    this.thumbnail,
    this.steps,
    this.materials,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'level': level.index,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'remark': remark,
      'thumbnail': thumbnail,
      'type': type.index,
      'steps': jsonEncode(steps),
      'materials': jsonEncode(materials?.map((m) => m.toMap()).toList())
    };
  }

  factory Menu.fromMap(Map<String, dynamic> map) {
    return Menu(
        id: map['id'],
        name: map['name'],
        level: MenuLevel.values[map['level']],
        type: MenuType.values[map['type']],
        createdAt: map['created_at'],
        updatedAt: map['updated_at'],
        remark: map['remark'],
        thumbnail: map['thumbnail'],
        steps: List<String>.from(jsonDecode(map['steps'] ?? '[]')),
        materials: List<Map<String, dynamic>>.from(
                jsonDecode(map['materials'] ?? '[]'))
            .map((o) => MenuMaterial.fromMap(o))
            .toList());
  }
}
