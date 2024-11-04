import 'dart:convert';

class StepItem {
  int step;
  String content;

  StepItem({required this.step, required this.content});

  Map<String, dynamic> toMap() {
    return {'step': step, 'content': content};
  }

  factory StepItem.fromMap(Map<String, dynamic> map) {
    return StepItem(step: map['step'], content: map['content']);
  }
}

class Menu {
  int? id;
  late String name;
  late int level;
  late bool isMain;
  int? createdAt;
  int? updatedAt;
  String? remark;
  String? thumbnail;
  List<int>? inventories;
  List<StepItem>? steps;

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
    this.inventories,
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
      'inventories': inventories?.join(','),
      'steps': jsonEncode(steps?.map((s) => s.toMap()).toList())
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
      inventories:
          map['inventories']?.split(',')?.map((i) => int.parse(i)).toList(),
      steps: jsonDecode(map['steps'])
          ?.map((j) => StepItem(
                step: j['step'],
                content: j['content'],
              ))
          .toList(),
    );
  }
}
