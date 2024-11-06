import 'package:cook_random/model/Ingredient.dart';
import 'package:flutter/material.dart';

class IngredientsSelectList extends StatelessWidget {
  const IngredientsSelectList({
    required this.selectedKeys,
    required this.ingredients,
    required this.onSelect,
    super.key,
  });

  final List<int> selectedKeys;
  final List<Ingredient> ingredients;
  final Function(int id, bool select) onSelect;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          var currentItem = ingredients[index];
          return ListTile(
            title: Text(currentItem.name),
            trailing: Checkbox(
                value: selectedKeys.contains(currentItem.id),
                onChanged: (select) {
                  if (select != null) {
                    onSelect(currentItem.id ?? 0, select);
                  }
                }),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            height: 8.0,
          );
        },
        itemCount: ingredients.length,
      ),
    );
  }
}
