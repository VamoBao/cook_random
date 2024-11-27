import 'package:cook_random/model/Menu.dart';
import 'package:flutter/material.dart';

class Utils {
  Utils();
  IconData getTypeIcon(MenuType type) {
    late IconData res;
    switch (type) {
      case MenuType.main:
        res = Icons.room_service;
      case MenuType.sideDish:
        res = Icons.local_dining;
      case MenuType.soup:
        res = Icons.soup_kitchen;
      case MenuType.dessert:
        res = Icons.icecream;
      case MenuType.snack:
        res = Icons.cookie;
    }
    return res;
  }

  bool isHardLevel(MenuLevel level) {
    return level.index > 1;
  }
}
