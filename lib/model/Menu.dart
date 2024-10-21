class Menu {
  int? id;
  late String name;
  late int level;
  late bool isMain;
  int? createdAt;
  int? updatedAt;

  Menu({required this.name,required this.level,required this.isMain,this.createdAt,this.updatedAt,this.id,});

  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'name':name,
      'level':level,
      'isMain':isMain?1:0,
      'created_at':createdAt,
      'updated_at':updatedAt,
    };
  }

  factory Menu.fromMap(Map<String,dynamic> map){
    return Menu(
      id:map['id'],
      name: map['name'],
      level: map['level'],
      isMain: map['isMain'],
      createdAt:map['created_at'],
      updatedAt:map['updated_at'],
    );
  }
}