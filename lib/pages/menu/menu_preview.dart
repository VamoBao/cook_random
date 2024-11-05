import 'dart:io';

import 'package:cook_random/model/Menu.dart';
import 'package:flutter/material.dart';

class MenuPreview extends StatefulWidget {
  const MenuPreview({required this.menu, super.key});

  final Menu menu;

  @override
  State<MenuPreview> createState() => _MenuPreviewState();
}

class _MenuPreviewState extends State<MenuPreview> {
  @override
  Widget build(BuildContext context) {
    final item = widget.menu;
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Hero(
            tag: item.name,
            child: Image.file(
              File(item.thumbnail ?? ''),
              width: double.infinity,
            ),
          ),
          Hero(
            tag: item.id.toString(),
            child: Text(
              item.name,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: theme.primary,
              ),
            ),
          )
        ],
      ),
    );
  }
}
