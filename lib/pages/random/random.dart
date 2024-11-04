import 'package:cook_random/common/MenuHelper.dart';
import 'package:cook_random/pages/random/random_result.dart';
import 'package:flutter/material.dart';

import '../../model/Menu.dart';

class Random extends StatefulWidget {
  const Random({super.key});

  @override
  State<Random> createState() => _RandomState();
}

class _RandomState extends State<Random> {
  final List<int> _selectedMain = [1];
  final List<int> _selectedLevel = [0, 1];
  int _count = 1;

  Menu menu = Menu(
    name: 'ces',
    level: 1,
    isMain: true,
    steps: [
      StepItem(step: 1, content: '123213'),
      StepItem(step: 2, content: 'caa123'),
    ],
    inventories: [12, 32],
  );

  Map<String, dynamic> menuMap = {
    'id': null,
    'name': 'ces',
    'level': 1,
    'isMain': 1,
    'created_at': null,
    'updated_at': null,
    'remark': null,
    'thumbnail': null,
    'inventories': '12,32',
    'steps': '[{step: 1, content: 123213},{step: 2, content: caa123}]'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('随机'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '类型',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              children: [0, 1]
                  .map((o) => FilterChip(
                        label: Text(o == 1 ? '主菜' : '其他'),
                        selected: _selectedMain.contains(o),
                        onSelected: (isSelect) {
                          setState(() {
                            if (isSelect) {
                              _selectedMain.add(o);
                            } else if (_selectedMain.length != 1) {
                              _selectedMain.remove(o);
                            }
                          });
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              '难度',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              children: ['简单', '普通', '耗时']
                  .asMap()
                  .entries
                  .map((entry) => FilterChip(
                        label: Text(entry.value),
                        selected: _selectedLevel.contains(entry.key),
                        onSelected: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              _selectedLevel.add(entry.key);
                            } else if (_selectedLevel.length != 1) {
                              _selectedLevel.remove(entry.key);
                            }
                          });
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              '数量',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      if (_count > 1) {
                        setState(() {
                          _count--;
                        });
                      }
                    });
                  },
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(0),
                    ),
                  ),
                  child: const Icon(Icons.remove),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _count.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _count++;
                    });
                  },
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(0),
                    ),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () async {
                final res = await MenuHelper.getFilterList(
                    _selectedMain, _selectedLevel);
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RandomResult(allMenus: res ?? [], count: _count)),
                  );
                }
              },
              child: const Text(
                '生成随机菜单',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            FilledButton(
                onPressed: () {
                  print(menu.toMap()['steps']);
                  print(menuMap['steps'].runtimeType);
                  print(Menu.fromMap(menuMap));
                },
                child: Text('转换'))
          ],
        ),
      ),
    );
  }
}
