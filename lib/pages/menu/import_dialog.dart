import 'package:cook_random/common/XCFParser.dart';
import 'package:cook_random/model/Menu.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ImportDialog extends StatefulWidget {
  const ImportDialog({required this.onImport, super.key});

  final Function(
      ({
        List<MenuMaterial>? materials,
        List<String>? steps,
        String? title,
        String? remark,
      })) onImport;

  @override
  State<ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends State<ImportDialog> {
  final TextEditingController _controller = TextEditingController();

  _parseXCFMenu() async {
    Response res = await Dio().get(_controller.text);
    widget.onImport(XCFParser().parseResponse(res));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('从链接导入'),
                actions: [
                  TextButton(
                      onPressed: () {
                        _parseXCFMenu();
                        Navigator.of(context).pop();
                      },
                      child: const Text('导入'))
                ],
                content: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    label: Text('下厨房分享链接'),
                    hintText: '请粘贴链接',
                  ),
                ),
              );
            });
      },
      icon: const Icon(Icons.add),
    );
  }
}
