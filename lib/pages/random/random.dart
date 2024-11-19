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
  final List<MenuLevel> _selectedLevel = [MenuLevel.normal, MenuLevel.easy];
  final List<int> _counts = List.generate(MenuType.values.length,
      (index) => MenuType.values[index] == MenuType.main ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('随机'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '菜谱类型及数量',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                ...MenuType.values.asMap().entries.map((e) {
                  return Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              child: Text(
                            e.value.label,
                            style: const TextStyle(fontSize: 16),
                          )),
                          Row(
                            children: [
                              TextButton(
                                onPressed: _counts[e.key] > 0
                                    ? () {
                                        setState(() {
                                          _counts[e.key] = _counts[e.key] - 1;
                                        });
                                      }
                                    : null,
                                child: const Icon(Icons.remove),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  _counts[e.key].toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: _counts[e.key] > 0
                                          ? FontWeight.bold
                                          : null),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _counts[e.key] = _counts[e.key] + 1;
                                  });
                                },
                                child: const Icon(Icons.add),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
                const Text(
                  '难度',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: MenuLevel.values
                        .asMap()
                        .entries
                        .map((e) => Container(
                              margin:
                                  EdgeInsets.only(left: e.key == 0 ? 0 : 16),
                              child: FilterChip(
                                label: Text(e.value.label),
                                selected: _selectedLevel.contains(e.value),
                                onSelected: (isSelected) {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedLevel.add(e.value);
                                    } else if (_selectedLevel.length != 1) {
                                      _selectedLevel.remove(e.value);
                                    }
                                  });
                                },
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _counts.any((c) => c > 0)
                      ? () async {
                          final res =
                              await MenuHelper.getFilterList(_selectedLevel);
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RandomResult(
                                      allMenus: res ?? [], counts: _counts)),
                            );
                          }
                        }
                      : null,
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
        ),
      ),
    );
  }
}
