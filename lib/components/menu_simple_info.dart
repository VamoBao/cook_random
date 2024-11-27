import 'package:cook_random/common/Utils.dart';
import 'package:cook_random/model/Menu.dart';
import 'package:flutter/material.dart';

/// 菜谱列表内菜谱基本信息(分类,难度等级)
class MenuSimpleInfo extends StatelessWidget {
  const MenuSimpleInfo({required this.menu, super.key});

  final Menu menu;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isHard = Utils().isHardLevel(menu.level);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: theme.surfaceContainerHighest,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 6,
          ),
          child: Row(
            children: [
              Icon(
                Utils().getTypeIcon(menu.type),
                size: 14,
                color: theme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                menu.type.label,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: theme.primary,
                ),
              )
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: isHard ? theme.tertiaryContainer : theme.primaryContainer,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 6,
          ),
          child: Row(
            children: [
              Icon(
                isHard ? Icons.access_time_filled : Icons.recommend,
                size: 14,
                color: isHard
                    ? theme.onTertiaryContainer
                    : theme.onPrimaryContainer,
              ),
              const SizedBox(width: 4),
              Text(
                menu.level.label,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: isHard
                      ? theme.onTertiaryContainer
                      : theme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
