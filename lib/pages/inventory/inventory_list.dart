import 'package:cook_random/pages/ingredients/ingredients_list.dart';
import 'package:cook_random/pages/inventory/inventory_detail.dart';
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
            icon: const Icon(Icons.list_alt),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InventoryDetail()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('入库'),
      ),
    );
  }
}
