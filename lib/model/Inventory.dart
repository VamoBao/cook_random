import 'Ingredient.dart';

class Inventory {
  int? id;
  late int ingredientsId;
  late StorageWay storageWay;
  late int storageTime;
  late int createdAt;
  late int updatedAt;
  String? ingredientName;
  int? shelfLife;

  Inventory({
    this.id,
    this.ingredientName,
    this.shelfLife,
    required this.ingredientsId,
    required this.storageWay,
    required this.storageTime,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      'storageWay': storageWay.index,
      'storageTime': storageTime,
      'ingredients_id': ingredientsId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory Inventory.fromMap(Map<String, dynamic> map) {
    return Inventory(
      id: map['id'],
      ingredientsId: map['ingredients_id'],
      storageWay: StorageWay.values[map['storageWay']],
      storageTime: map['storageTime'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      ingredientName: map['ingredientName'],
      shelfLife: map['shelfLife'],
    );
  }
}
