import 'package:cook_random/model/Menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CartSheet extends StatefulWidget {
  const CartSheet({required this.materials, super.key});

  final List<MenuMaterial> materials;

  @override
  State<CartSheet> createState() => _CartSheetState();
}

class _CartSheetState extends State<CartSheet> {
  List<int> _selectIndex = [];
  bool? get _isCheckAll {
    if (_selectIndex.isEmpty) {
      return false;
    } else if (_selectIndex.length == widget.materials.length) {
      return true;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.materials;
    return SizedBox(
      height: 450,
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '选择采购食材',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    final text = widget.materials
                        .asMap()
                        .entries
                        .where((e) => _selectIndex.contains(e.key))
                        .map((e) => '${e.value.name}\t${e.value.unit}')
                        .join('\n');
                    Clipboard.setData(
                      ClipboardData(text: text),
                    ).then((_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('已复制到剪贴板'),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    });
                  },
                  child: const Text('确定'),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              // shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index].name),
                  subtitle: Text(items[index].unit),
                  trailing: Checkbox(
                      value: _selectIndex.contains(index),
                      onChanged: (select) {
                        if (select == true) {
                          setState(() {
                            _selectIndex.add(index);
                          });
                        } else {
                          setState(() {
                            _selectIndex.remove(index);
                          });
                        }
                      }),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: items.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('全选'),
                Checkbox(
                    value: _isCheckAll,
                    tristate: true,
                    onChanged: (selectAll) {
                      if (selectAll == true ||
                          (selectAll == false && _isCheckAll == null)) {
                        setState(() {
                          _selectIndex = widget.materials
                              .asMap()
                              .entries
                              .map((e) => e.key)
                              .toList();
                        });
                      } else {
                        setState(() {
                          _selectIndex = [];
                        });
                      }
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
