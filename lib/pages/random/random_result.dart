import 'dart:math';

import 'package:cook_random/model/Menu.dart';
import 'package:flutter/material.dart';

class RandomResult extends StatefulWidget {
  const RandomResult({required this.allMenus, required this.counts, super.key});

  final List<Menu> allMenus;
  final List<int> counts;

  @override
  State<RandomResult> createState() => _RandomResultState();
}

class _RandomResultState extends State<RandomResult> {
  List<Menu> _result = [];
  late List<List<Menu>> _res;

  List<Menu> _randomMenus(int count, List<Menu> menus) {
    print(menus);
    if (count >= menus.length) {
      return menus;
    } else {
      List<Menu> temp = [];
      for (int i = 0; i < count; i++) {
        List<Menu> lastOptions = menus.where((o) => !temp.contains(o)).toList();
        int randomIndex = Random().nextInt(lastOptions.length);
        temp.add(lastOptions[randomIndex]);
      }
      return temp;
    }
  }

  _random() {
    setState(() {
      _res = widget.counts.asMap().entries.map((e) {
        return _randomMenus(
            e.value,
            widget.allMenus
                .where((m) => m.type == MenuType.values[e.key])
                .toList());
      }).toList();
    });
  }

  @override
  void initState() {
    _random();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('生成结果'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _res.every((r) => r.isEmpty)
            ? const Text('无满足条件的菜单')
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _res.asMap().entries.map((e) {
                    return Visibility(
                        visible: e.value.isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              MenuType.values[e.key].label,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: e.value.map((o) {
                                return InputChip(label: Text(o.name));
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ));
                  }).toList(),
                ),
              ),
      ),
    );
  }
}
