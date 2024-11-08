import 'dart:io';

import 'package:cook_random/common/IngredientHelper.dart';
import 'package:cook_random/model/Ingredient.dart';
import 'package:cook_random/model/Menu.dart';
import 'package:flutter/material.dart';

class MenuPreview extends StatefulWidget {
  const MenuPreview({required this.menu, super.key});

  final Menu menu;

  @override
  State<MenuPreview> createState() => _MenuPreviewState();
}

class _MenuPreviewState extends State<MenuPreview> {
  late List<Ingredient> _ingredients = [];

  _loadIngredients() async {
    var res = await IngredientHelper.getList();
    setState(() {
      _ingredients = res;
    });
  }

  @override
  void initState() {
    _loadIngredients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.menu;
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool isScroll) {
          return [
            SliverAppBar(
              backgroundColor: theme.surface,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: item.name,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(24)),
                    child: Image.file(
                      File(item.thumbnail ?? ''),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              expandedHeight: MediaQuery.of(context).size.width,
              pinned: true,
              floating: true,
            )
          ];
        },
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: item.id.toString(),
                child: SizedBox(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: theme.primary,
                    ),
                  ),
                ),
              ),
              Divider(
                height: 16,
                color: theme.outline.withOpacity(0.15),
              ),
              Visibility(
                visible: item.ingredients!.isNotEmpty,
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
                          color: theme.tertiaryContainer,
                        ),
                      ),
                      Text(
                        '食材',
                        style: TextStyle(
                          fontSize: 22,
                          color: theme.onTertiaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: item.ingredients!.isNotEmpty,
                child: Card.filled(
                  margin: const EdgeInsets.only(top: 8),
                  color: theme.surfaceContainerLow,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final currentIngredient = _ingredients.firstWhere(
                            (o) => o.id == item.ingredients?[index],
                          );
                          return Flex(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            direction: Axis.horizontal,
                            children: [
                              Text(
                                currentIngredient.name,
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
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: theme.primary,
                            height: 16,
                          );
                        },
                        itemCount: item.ingredients?.length ?? 0,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: item.steps!.isNotEmpty,
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
                          color: theme.tertiaryContainer,
                        ),
                      ),
                      Text(
                        '制作步骤',
                        style: TextStyle(
                          fontSize: 22,
                          color: theme.onTertiaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: true,
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final step = item.steps?[index] ?? '';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '步骤${index + 1}',
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.43,
                              ),
                            ),
                            Text(step,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                )),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 24),
                      itemCount: item.steps?.length ?? 0)),
              Visibility(
                visible: item.remark != '',
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
                          color: theme.tertiaryContainer,
                        ),
                      ),
                      Text(
                        '备注',
                        style: TextStyle(
                          fontSize: 22,
                          color: theme.onTertiaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: item.remark != '',
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 0,
                    color: theme.secondaryContainer,
                    margin: const EdgeInsets.only(top: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        item.remark ?? '',
                        style: TextStyle(
                          color: theme.secondary,
                          fontSize: 14,
                          height: 1.43,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Center(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('返 回'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
