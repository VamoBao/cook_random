import 'dart:convert';

class Menu {
  int? id;
  late String name;
  late int level;
  late bool isMain;
  int? createdAt;
  int? updatedAt;
  String? remark;
  String? thumbnail;
  List<int>? ingredients;
  List<String>? steps;

  Menu({
    required this.name,
    required this.level,
    required this.isMain,
    this.createdAt,
    this.updatedAt,
    this.id,
    this.remark,
    this.thumbnail,
    this.steps,
    this.ingredients,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'isMain': isMain ? 1 : 0,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'remark': remark,
      'thumbnail': thumbnail,
      'ingredients': jsonEncode(ingredients),
      'steps': jsonEncode(steps),
    };
  }

  factory Menu.fromMap(Map<String, dynamic> map) {
    return Menu(
      id: map['id'],
      name: map['name'],
      level: map['level'],
      isMain: map['isMain'] == 1,
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      remark: map['remark'],
      thumbnail: map['thumbnail'],
      ingredients: List<int>.from(jsonDecode(map['ingredients'] ?? '[]')),
      steps: List<String>.from(jsonDecode(map['steps'] ?? '[]')),
    );
  }
}
