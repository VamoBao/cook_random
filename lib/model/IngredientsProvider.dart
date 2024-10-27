import 'package:cook_random/model/Ingredient.dart';
import 'package:flutter/foundation.dart';

class IngredientsProvider with ChangeNotifier {
  List<Ingredient> _ingredients = [];

  List<Ingredient> get ingredients => _ingredients;

  set ingredients(List<Ingredient> ingredients) {
    _ingredients = ingredients;
    notifyListeners();
  }
}
