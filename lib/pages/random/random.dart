import 'package:cook_random/common/MenuHelper.dart';
import 'package:cook_random/model/Menu.dart';
import 'package:cook_random/pages/random/random_result.dart';
import 'package:flutter/material.dart';

class Random extends StatefulWidget {
  const Random({super.key});

  @override
  State<Random> createState() => _RandomState();
}

class _RandomState extends State<Random> {
  final List<MenuType> _selectedMain = [MenuType.main];
  final List<MenuLevel> _selectedLevel = [MenuLevel.normal, MenuLevel.easy];
  int _count = 1;

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
              alignment: WrapAlignment.center,
              spacing: 16,
              children: MenuType.values
                  .map((o) => FilterChip(
                        label: Text(o.label),
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
              alignment: WrapAlignment.center,
              spacing: 16,
              children: MenuLevel.values
                  .map((o) => FilterChip(
                        label: Text(o.label),
                        selected: _selectedLevel.contains(o),
                        onSelected: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              _selectedLevel.add(o);
                            } else if (_selectedLevel.length != 1) {
                              _selectedLevel.remove(o);
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
            )
          ],
        ),
      ),
    );
  }
}
