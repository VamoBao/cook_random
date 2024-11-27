import 'dart:io';

import 'package:cook_random/components/menu_simple_info.dart';
import 'package:cook_random/model/Menu.dart';
import 'package:flutter/material.dart';

class MenuListItem extends StatelessWidget {
  const MenuListItem({required this.menu, required this.trailing, super.key});

  final Menu menu;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final currentItem = menu;
    final theme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 110,
      child: Row(
        children: [
          Hero(
            tag: currentItem.id ?? 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: currentItem.thumbnail == null
                  ? Image.asset(
                      'assets/images/placeholder.jpg',
                      width: 110,
                      height: 110,
                      fit: BoxFit.fill,
                    )
                  : Image.file(
                      File(currentItem.thumbnail ?? ''),
                      width: 110,
                      height: 110,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(left: 16),
              // width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题部分
                  SizedBox(
                    height: 24,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Text(
                            currentItem.name,
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
                  const SizedBox(height: 8),
                  Container(
                    height: 4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.primaryContainer,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      height: double.infinity,
                      child: Text(
                        currentItem.remark == ''
                            ? currentItem.steps!.join(';')
                            : (currentItem.remark ?? ''),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  MenuSimpleInfo(menu: currentItem)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
