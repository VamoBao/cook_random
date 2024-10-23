import 'package:cook_random/pages/ingredients/ingredients_list.dart';
import 'package:flutter/material.dart';

class InventoryList extends StatefulWidget {
  const InventoryList({super.key});

  @override
  State<InventoryList> createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
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
            icon: Icon(Icons.list_alt),
          )
        ],
      ),
    );
  }
}
