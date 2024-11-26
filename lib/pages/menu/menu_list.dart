import 'dart:io';

import 'package:cook_random/common/MenuHelper.dart';
import 'package:cook_random/components/menu_list_item.dart';
import 'package:cook_random/components/menu_list_simple_item.dart';
import 'package:cook_random/model/Menu.dart';
import 'package:cook_random/pages/menu/menu_detail.dart';
import 'package:cook_random/pages/menu/menu_preview.dart';
import 'package:flutter/material.dart';

class MenuList extends StatefulWidget {
  const MenuList({super.key});

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  List<Menu> _data = [];
  final SearchController _controller = SearchController();

  _loadList() async {
    var res = await MenuHelper.getList();
    setState(() {
      _data = res;
    });
  }

  _unFocusSearch() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  void initState() {
    _loadList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme theme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              toolbarHeight: 72,
              backgroundColor: Colors.transparent,
              title: SearchAnchor.bar(
                searchController: _controller,
                barHintText: '搜索菜单名',
                barElevation: const WidgetStatePropertyAll<double>(0),
                viewLeading: IconButton(
                  onPressed: () {
                    _controller.text = '';
                    _unFocusSearch();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                suggestionsBuilder: (context, controller) async {
                  List<Menu> res = [];
                  if (controller.text != '') {
                    res = await MenuHelper.getSearchList(controller.text);
                  }
                  return res.map((m) {
                    return ListTile(
                      title: Text(m.name),
                      subtitle: Text(m.remark ?? ''),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: theme.secondary,
                      ),
                      leading: m.thumbnail == null
                          ? Image.asset(
                              'assets/images/placeholder.jpg',
                              fit: BoxFit.fill,
                            )
                          : Image.file(
                              File(m.thumbnail ?? ''),
                              fit: BoxFit.fill,
                            ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MenuPreview(menu: m);
                        }));
                      },
                    );
                  });
                },
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverList.separated(
                itemCount: _data.length,
                itemBuilder: (BuildContext context, int index) {
                  var currentItem = _data[index];
                  bool noRemark =
                      currentItem.remark == '' || currentItem.remark == null;
                  Widget trailing = PopupMenuButton(
                    padding: const EdgeInsets.all(0),
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
                                  return MenuDetail(
                                    menu: currentItem,
                                  );
                                },
                              ),
                            ).then((v) {
                              _unFocusSearch();
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
                                          await MenuHelper.remove(
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
                    icon: Icon(
                      Icons.more_vert,
                      size: 20,
                      color: theme.onSurface.withAlpha(50),
                    ),
                  );
                  return Card.filled(
                    color: theme.surfaceContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MenuPreview(menu: currentItem);
                        })).then((_) {
                          _unFocusSearch();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: noRemark
                            ? MenuListSimpleItem(
                                menu: currentItem,
                                trailing: trailing,
                              )
                            : MenuListItem(
                                menu: currentItem, trailing: trailing),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 0,
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MenuDetail()),
          ).then((v) {
            _unFocusSearch();
            if (v == 'save') {
              _loadList();
            }
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('新增菜单'),
      ),
    );
  }
}
