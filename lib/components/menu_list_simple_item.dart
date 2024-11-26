import 'dart:io';

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
      child: Row(
        children: [
          Hero(
            tag: menu.id ?? 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: menu.thumbnail == null
                  ? Image.asset(
                      'assets/images/placeholder.jpg',
                      width: 112,
                      height: 76,
                      fit: BoxFit.fill,
                    )
                  : Image.file(
                      File(menu.thumbnail ?? ''),
                      width: 112,
                      height: 76,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
          Flexible(
            child: Container(
              height: 76,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99),
                          color: menu.level.index > 1
                              ? theme.errorContainer
                              : theme.primaryContainer,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          menu.level.label,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: menu.level.index > 1
                                ? theme.onErrorContainer
                                : theme.onPrimaryContainer,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
