import 'package:cook_random/common/IngredientHelper.dart';
import 'package:cook_random/model/Ingredient.dart';
import 'package:cook_random/pages/ingredients/ingredient_detail.dart';
import 'package:flutter/material.dart';

class IngredientsList extends StatefulWidget {
  const IngredientsList({super.key});

  @override
  State<IngredientsList> createState() => _IngredientsListState();
}

class _IngredientsListState extends State<IngredientsList> {
  List<Ingredient> _data = [];

  _loadList() async {
    var res = await IngredientHelper.getList();
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
        title: const Text('食材清单'),
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          var currentItem = _data[index];
          return ListTile(
            title: Text(currentItem.name),
            subtitle: currentItem.remark == ''
                ? null
                : Text(
                    currentItem.remark ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                            return IngredientDetail(
                              ingredient: currentItem,
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
                                    await IngredientHelper.remove(
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
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              height: 4,
            ),
          );
        },
        itemCount: _data.length,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const IngredientDetail()),
          ).then((v) {
            if (v == 'save') {
              _loadList();
            }
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('新增食材'),
      ),
    );
  }
}
