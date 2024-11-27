import 'dart:io';

import 'package:cook_random/components/menu_simple_info.dart';
import 'package:cook_random/model/Menu.dart';
import 'package:flutter/material.dart';

class MenuListSimpleItem extends StatelessWidget {
  const MenuListSimpleItem(
      {required this.menu, required this.trailing, super.key});

  final Menu menu;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          Hero(
            tag: menu.id ?? 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: menu.thumbnail == null
                  ? Image.asset(
                      'assets/images/placeholder.jpg',
                      width: 110,
                      height: 60,
                      fit: BoxFit.fitWidth,
                    )
                  : Image.file(
                      File(menu.thumbnail ?? ''),
                      width: 110,
                      height: 60,
                      fit: BoxFit.fitWidth,
                    ),
            ),
          ),
          Flexible(
            child: Container(
              height: 60,
              margin: const EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 24,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Text(
                            menu.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: theme.surfaceTint,
                              height: 1.25,
                            ),
                          ),
                        ),
                        trailing
                      ],
                    ),
                  ),
                  MenuSimpleInfo(menu: menu)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
