import 'dart:io';

import 'package:cook_random/common/MenuHelper.dart';
import 'package:cook_random/common/Utils.dart';
import 'package:cook_random/model/Ingredient.dart';
import 'package:cook_random/model/Menu.dart';
import 'package:cook_random/pages/menu/menu_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MenuPreview extends StatefulWidget {
  const MenuPreview({required this.menu, super.key});

  final Menu menu;

  @override
  State<MenuPreview> createState() => _MenuPreviewState();
}

class _MenuPreviewState extends State<MenuPreview> {
  late Menu _item;
  bool _shouldRefresh = false;

  void _refreshItem(int id) async {
    final newItem = await MenuHelper.getById(id);
    if (newItem != null) {
      setState(() {
        _item = newItem;
        _shouldRefresh = true;
      });
    }
  }

  @override
  void initState() {
    _item = widget.menu;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isHard = Utils().isHardLevel(_item.level);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        } else {
          Navigator.pop(context, _shouldRefresh);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_item.name),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  clipBehavior: Clip.hardEdge,
                  color: theme.primaryContainer.withAlpha(100),
                  elevation: 0,
                  child: Column(
                    children: [
                      Hero(
                        tag: _item.id ?? 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: _item.thumbnail == null
                              ? Image.asset(
                                  'assets/images/placeholder.jpg',
                                  width: double.infinity,
                                  // height: 240,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(_item.thumbnail ?? ''),
                                  width: double.infinity,
                                  // height: 240,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _item.name,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: theme.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Utils().getTypeIcon(_item.type),
                                      color: theme.primary.withAlpha(125),
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(
                                      isHard
                                          ? Icons.access_time_filled
                                          : Icons.thumb_up_alt,
                                      color: theme.primary.withAlpha(125),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton.filledTonal(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return MenuDetail(
                                                menu: _item,
                                              );
                                            },
                                          ),
                                        ).then((v) {
                                          if (v == 'save' && _item.id != null) {
                                            final id = _item.id;
                                            _refreshItem(id!);
                                          }
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        // size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    FilledButton.icon(
                                      onPressed: () {
                                        if (_item.materials!.isNotEmpty) {
                                          final String text =
                                              _item.materials!.map((material) {
                                            return '${material.name}\t${material.unit}';
                                          }).join('\n');
                                          Clipboard.setData(
                                            ClipboardData(text: text),
                                          ).then((_) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text('已复制到剪贴板'),
                                                ),
                                              );
                                            }
                                          });
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.shopping_cart,
                                        size: 18,
                                      ),
                                      label: const Text('采购清单'),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: _item.materials!.isNotEmpty,
                  child: SizedBox(
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 6,
                            width: 50,
                            color: theme.primaryContainer,
                          ),
                        ),
                        const Text('食材', style: TextStyle(fontSize: 22)),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _item.materials!.isNotEmpty,
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: MaterialList(
                      list: _item.materials ?? [],
                      theme: theme,
                    ),
                  ),
                ),
                Visibility(
                  visible: _item.steps!.isNotEmpty,
                  child: Container(
                    margin: const EdgeInsets.only(top: 16),
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 6,
                            width: 90,
                            color: theme.primaryContainer,
                          ),
                        ),
                        const Text('制作步骤', style: TextStyle(fontSize: 22)),
                      ],
                    ),
                  ),
                ),
                Visibility(
                    visible: true, child: StepList(steps: _item.steps ?? [])),
                Visibility(
                  visible: _item.remark != '',
                  child: Container(
                    margin: const EdgeInsets.only(top: 16),
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 6,
                            width: 50,
                            color: theme.primaryContainer,
                          ),
                        ),
                        const Text('备注', style: TextStyle(fontSize: 22)),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _item.remark != '',
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 0,
                      color: theme.surfaceContainerLow,
                      margin: const EdgeInsets.only(top: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _item.remark ?? '',
                          style: TextStyle(
                            color: theme.secondary,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IngredientsList extends StatelessWidget {
  const IngredientsList(
      {required this.ingredients, required this.theme, super.key});

  final List<Ingredient> ingredients;
  final ColorScheme theme;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (int i = 0; i < ingredients.length; i++) {
      children.add(Flex(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.horizontal,
        children: [
          Text(
            ingredients[i].name,
            style: const TextStyle(
              fontSize: 14,
              height: 1.7,
            ),
          ),
          const Text(
            '食材充足',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              height: 1.7,
            ),
          ),
        ],
      ));
      if (i != ingredients.length - 1) {
        children.add(Divider(
          color: theme.primaryContainer,
          height: 16,
        ));
      }
    }

    return Card(
      margin: const EdgeInsets.only(top: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: theme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}

class StepList extends StatelessWidget {
  const StepList({required this.steps, super.key});

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (int i = 0; i < steps.length; i++) {
      children.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '步骤${i + 1}',
              style: const TextStyle(
                fontSize: 14,
                height: 1.43,
              ),
            ),
            Text(steps[i],
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                )),
          ],
        ),
      );
      if (i != steps.length - 1) {
        children.add(const SizedBox(height: 24));
      }
    }
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class MaterialList extends StatelessWidget {
  const MaterialList({required this.list, required this.theme, super.key});

  final List<MenuMaterial> list;
  final ColorScheme theme;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    TextStyle style = TextStyle(
      color: theme.onSecondaryContainer,
      fontSize: 14,
    );
    for (int i = 0; i < list.length; i++) {
      children.add(SizedBox(
        height: 24,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              list[i].name,
              style: style,
            ),
            Text(
              list[i].unit,
              style: style,
            ),
          ],
        ),
      ));
      if (i != list.length - 1) {
        children.add(const Divider(height: 16));
      }
    }
    return Card(
      color: theme.surfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
