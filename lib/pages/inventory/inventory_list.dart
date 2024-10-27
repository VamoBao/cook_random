import 'package:cook_random/common/InventoryHelper.dart';
import 'package:cook_random/model/Inventory.dart';
import 'package:cook_random/pages/ingredients/ingredients_list.dart';
import 'package:cook_random/pages/inventory/inventory_detail.dart';
import 'package:flutter/material.dart';

class InventoryList extends StatefulWidget {
  const InventoryList({super.key});

  @override
  State<InventoryList> createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  List<Inventory> _data = [];

  _loadList() async {
    var res = await InventoryHelper.getList();
    setState(() {
      _data = res;
    });
  }

  @override
  void initState() {
    _loadList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('库存'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const IngredientsList()),
              );
            },
            icon: const Icon(Icons.list_alt),
          )
        ],
      ),
      body: ListView.separated(
        itemCount: _data.length,
        itemBuilder: (BuildContext context, int index) {
          Inventory currentItem = _data[index];
          int duration = DateTime.now()
              .difference(
                  DateTime.fromMillisecondsSinceEpoch(currentItem.storageTime))
              .inDays;
          int lastDays = (currentItem.shelfLife ?? 7) - duration;
          return ListTile(
            title: Text(currentItem.ingredientName ?? ''),
            subtitle: Text(
              lastDays >= 0 ? '保质期剩余：$lastDays天' : '已过期',
              style: TextStyle(color: lastDays < 3 ? Colors.red : null),
            ),
            trailing: PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: 'edit',
                    child: const Text('编辑'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return InventoryDetail(
                              inventory: currentItem,
                            );
                          },
                        ),
                      ).then((v) {
                        if (v == 'save') {
                          _loadList();
                        }
                      });
                    },
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: const Text(
                      '删除',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('删除'),
                            content: const Text('删除菜单后不可恢复，是否确认删除'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('取消'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (currentItem.id != null) {
                                    await InventoryHelper.remove(
                                        currentItem.id ?? 0);
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                    }
                                    _loadList();
                                  }
                                },
                                child: const Text('确认'),
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                ];
              },
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Divider(
              height: 4,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InventoryDetail()),
          ).then((v) {
            if (v == 'save') {
              _loadList();
            }
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('入库'),
      ),
    );
  }
}
