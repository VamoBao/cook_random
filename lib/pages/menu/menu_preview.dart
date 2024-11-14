import 'dart:io';

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
  @override
  Widget build(BuildContext context) {
    final item = widget.menu;
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.menu.name),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Hero(
                tag: item.id ?? 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: item.thumbnail == null
                      ? Image.asset(
                          'assets/images/placeholder.jpg',
                          width: double.infinity,
                          height: 240,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(item.thumbnail ?? ''),
                          width: double.infinity,
                          height: 240,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: theme.primary,
                  ),
                ),
              ),
              Divider(
                height: 16,
                color: theme.outline.withOpacity(0.15),
              ),
              Visibility(
                visible: item.materials!.isNotEmpty,
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
                visible: item.materials!.isNotEmpty,
                child: Container(
                  margin: EdgeInsets.only(top: 8),
                  child: MaterialList(
                    list: item.materials ?? [],
                    theme: theme,
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
                          color: theme.primaryContainer,
                        ),
                      ),
                      const Text('制作步骤', style: TextStyle(fontSize: 22)),
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: true, child: StepList(steps: item.steps ?? [])),
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
                          color: theme.primaryContainer,
                        ),
                      ),
                      const Text('备注', style: TextStyle(fontSize: 22)),
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
                    color: theme.surfaceContainerLow,
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
