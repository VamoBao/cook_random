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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const IngredientDetail()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('新增食材'),
      ),
    );
  }
}
