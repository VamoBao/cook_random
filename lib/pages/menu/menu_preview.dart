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
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool isScroll) {
          return [
            SliverAppBar(
              backgroundColor: theme.surface,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: item.name,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(24)),
                    child: Image.file(
                      File(item.thumbnail ?? ''),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              expandedHeight: MediaQuery.of(context).size.width,
              pinned: true,
              floating: true,
            )
          ];
        },
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: item.id.toString(),
                child: SizedBox(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: theme.primary,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
