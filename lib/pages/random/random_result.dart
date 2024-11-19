import 'dart:io';
import 'dart:math';

import 'package:cook_random/model/Menu.dart';
import 'package:cook_random/pages/menu/menu_preview.dart';
import 'package:flutter/material.dart';

class RandomResult extends StatefulWidget {
  const RandomResult({required this.allMenus, required this.counts, super.key});

  final List<Menu> allMenus;
  final List<int> counts;

  @override
  State<RandomResult> createState() => _RandomResultState();
}

class _RandomResultState extends State<RandomResult> {
  late List<List<Menu>> _res;

  List<Menu> _randomMenus(int count, List<Menu> menus) {
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
    final ColorScheme theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('生成结果'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _res.every((r) => r.isEmpty)
            ? const Center(child: Text('无满足条件的菜单'))
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
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                MenuType.values[e.key].label,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            GridView.count(
                              // GridView所在的Column在一个滚动组件里面,所以需要禁止GridView滚动
                              shrinkWrap: true, //自适应高度
                              physics:
                                  const NeverScrollableScrollPhysics(), //禁止滚动
                              crossAxisCount: 3,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                              childAspectRatio: 0.73,
                              children: e.value.map((o) {
                                return Card(
                                  elevation: 0,
                                  color: theme.surfaceContainer,
                                  clipBehavior: Clip.hardEdge,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return MenuPreview(menu: o);
                                      }));
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Hero(
                                          tag: o.id ?? 0,
                                          child: ClipRRect(
                                            child: o.thumbnail == null
                                                ? Image.asset(
                                                    'assets/images/placeholder.jpg',
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.file(
                                                    File(o.thumbnail ?? ''),
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Text(
                                            o.name,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
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
