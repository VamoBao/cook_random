enum IngredientType {
  ///蔬菜
  vegetable('蔬菜'),

  ///调味品
  condiment('调味品'),

  ///肉类
  meat('肉类'),

  ///水果
  fruit('水果');

  final String label;

  const IngredientType(this.label);
}

enum StorageWay {
  ///冷藏
  refrigerate('冷藏'),

  ///冷冻
  freezing('冷冻'),

  ///常温储存
  normal('常温保存');

  final String label;

  const StorageWay(this.label);
}

class Ingredient {
  int? id;
  late String name;
  List<String>? alias;
  late IngredientType type;
  late int shelfLife;
  late StorageWay recommendStorageWay;
  String? remark;
  late int createdAt;
  late int updatedAt;

  Ingredient({
    this.id,
    required this.name,
    required this.type,
    required this.shelfLife,
    required this.recommendStorageWay,
    required this.createdAt,
    required this.updatedAt,
    this.remark,
    this.alias,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'shelfLife': shelfLife,
      'alias': alias?.join(","),
      'type': type.index,
      'recommendStorageWay': recommendStorageWay.index,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'remark': remark,
    };
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'],
      name: map['name'],
      alias: ((map['alias'] ?? '') as String).split(","),
      shelfLife: map['shelfLife'],
      type: IngredientType.values[map['type']],
      recommendStorageWay: StorageWay.values[map['recommendStorageWay']],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      remark: map['remark'],
    );
  }
}
