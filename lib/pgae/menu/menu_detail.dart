import 'package:cook_random/common/MenuHelper.dart';
import 'package:cook_random/model/Menu.dart';
import 'package:flutter/material.dart';

class MenuDetail extends StatefulWidget {
  const MenuDetail({this.menu, super.key});

  final Menu? menu;

  @override
  State<MenuDetail> createState() => _MenuDetailState();
}

class _MenuDetailState extends State<MenuDetail> {
  final GlobalKey _form = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final List<String> _levelList = ['简单', '普通', '耗时'];
  int _level = 0;
  bool _isMain = true;

  @override
  void initState() {
    if (widget.menu != null) {
      _nameController.text = widget.menu!.name;
      _remarkController.text = widget.menu!.remark ?? '';
      setState(() {
        _level = widget.menu!.level;
        _isMain = widget.menu!.isMain;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.menu == null ? '新增菜单' : '编辑菜单'),
      ),
      body: Form(
        key: _form,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        label: Text('菜单名称'),
                        hintText: '请输入菜单的名称',
                      ),
                      validator: (v) => v!.trim().isEmpty ? '菜单名不能为空' : null,
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField(
                      value: _level,
                      items: [0, 1, 2]
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(_levelList[e]),
                              ))
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          _level = v ?? 0;
                        });
                      },
                      decoration: const InputDecoration(label: Text('难度')),
                    ),
                    const SizedBox(height: 16.0),
                    SwitchListTile(
                      value: _isMain,
                      title: const Text('是否主菜'),
                      contentPadding: const EdgeInsets.only(left: 0, right: 0),
                      onChanged: (v) {
                        setState(() {
                          _isMain = v;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _remarkController,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        label: Text('备注说明'),
                        hintText: '备注内容',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 16.0),
                width: double.infinity,
                child: Builder(
                  builder: (context) {
                    return FilledButton(
                      onPressed: () async {
                        if (Form.of(context).validate()) {
                          if (widget.menu != null) {
                            var newMenu = Menu(
                              id: widget.menu?.id,
                              name: _nameController.text,
                              level: _level,
                              isMain: _isMain,
                              remark: _remarkController.text,
                              createdAt: widget.menu?.createdAt ??
                                  DateTime.now().millisecondsSinceEpoch,
                              updatedAt: DateTime.now().millisecondsSinceEpoch,
                            );
                            await MenuHelper.update(newMenu);
                          } else {
                            var newMenu = Menu(
                              name: _nameController.text,
                              level: _level,
                              isMain: _isMain,
                              remark: _remarkController.text,
                              createdAt: DateTime.now().millisecondsSinceEpoch,
                              updatedAt: DateTime.now().millisecondsSinceEpoch,
                            );
                            await MenuHelper.insert(newMenu);
                          }
                          if (context.mounted) {
                            Navigator.pop(context, 'save');
                          }
                        }
                      },
                      child: const Text('保存'),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
