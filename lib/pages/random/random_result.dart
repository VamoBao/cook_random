import 'dart:math';

import 'package:cook_random/model/Menu.dart';
import 'package:flutter/material.dart';

class RandomResult extends StatefulWidget {
  const RandomResult({required this.allMenus, required this.count, super.key});

  final List<Menu> allMenus;
  final int count;

  @override
  State<RandomResult> createState() => _RandomResultState();
}

class _RandomResultState extends State<RandomResult> {
  List<Menu> _result = [];

  _randomResult() {
    if (widget.count >= widget.allMenus.length) {
      setState(() {
        _result = widget.allMenus;
      });
    } else {
      List<Menu> temp = [];
      for (int i = 0; i < widget.count; i++) {
        List<Menu> lastOptions =
            widget.allMenus.where((o) => !temp.contains(o)).toList();
        int randomIndex = Random().nextInt(lastOptions.length);
        temp.add(lastOptions[randomIndex]);
      }
      setState(() {
        _result = temp;
      });
    }
  }

  @override
  void initState() {
    _randomResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('生成结果'),
      ),
      body: Center(
        child: _result.isEmpty
            ? const Text('无满足条件的菜单')
            : Wrap(
                spacing: 16,
                children: _result
                    .map((o) => RawChip(
                          label: Text(o.name),
                        ))
                    .toList(),
              ),
      ),
    );
  }
}
