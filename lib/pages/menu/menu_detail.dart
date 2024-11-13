import 'package:cook_random/common/MenuHelper.dart';
import 'package:cook_random/components/image_picker.dart';
import 'package:cook_random/components/material_input.dart';
import 'package:cook_random/model/Menu.dart';
import 'package:cook_random/pages/menu/import_dialog.dart';
import 'package:flutter/material.dart';

class MenuDetail extends StatefulWidget {
  const MenuDetail({this.menu, super.key});

  final Menu? menu;

  @override
  State<MenuDetail> createState() => _MenuDetailState();
}

class _MenuDetailState extends State<MenuDetail> {
  /// 表单key
  final GlobalKey _form = GlobalKey<FormState>();

  ///名称输入controller
  final TextEditingController _nameController = TextEditingController();

  /// 备注输入controller
  final TextEditingController _remarkController = TextEditingController();

  /// 当前选择的难度
  MenuLevel _level = MenuLevel.normal;

  /// 菜谱类型
  MenuType _type = MenuType.main;

  /// 图片地址
  String? _imagePath;

  /// 步骤输入框controller集合
  List<TextEditingController> _stepControllers = [];

  List<MenuMaterial> _materials = [];

  @override
  void initState() {
    // 如果menu不为空,表示是编辑状态
    if (widget.menu != null) {
      _nameController.text = widget.menu!.name;
      _remarkController.text = widget.menu!.remark ?? '';
      setState(() {
        _level = widget.menu!.level;
        _imagePath = widget.menu?.thumbnail;
        // 初始化步骤controller
        if (widget.menu?.steps?.length != 0) {
          _stepControllers = List.generate(
            widget.menu!.steps!.length,
            (index) => TextEditingController(
              text: widget.menu!.steps![index],
            ),
          );
        }
        _materials = widget.menu?.materials ?? [];
        _type = widget.menu!.type;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.menu == null ? '新增菜单' : '编辑菜单'),
        actions: [
          ImportDialog(
            onImport: (values) {
              if (values.materials != null && values.materials?.length != 0) {
                setState(() {
                  _materials = values.materials!;
                });
              }
              if (values.steps != null && values.steps?.length != 0) {
                setState(() {
                  _stepControllers = List.generate(
                    values.steps!.length,
                    (index) => TextEditingController(
                      text: values.steps![index],
                    ),
                  );
                });
              }
              if (values.title != null) {
                _nameController.text = values.title!;
              }
              if (values.remark != null) {
                _remarkController.text = values.remark!;
              }
            },
          )
        ],
      ),
      body: Form(
        key: _form,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 16.0),
                      ImageTool(
                        imagePath: _imagePath,
                        onSave: (path) {
                          setState(() {
                            _imagePath = path;
                          });
                        },
                      ),
                      const SizedBox(height: 32.0),
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
                        value: _type,
                        items: MenuType.values
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.label),
                                ))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            _type = v!;
                          });
                        },
                        decoration: const InputDecoration(label: Text('类型')),
                      ),
                      const SizedBox(height: 16.0),
                      DropdownButtonFormField(
                        value: _level,
                        items: MenuLevel.values
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.label),
                                ))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            _level = v!;
                          });
                        },
                        decoration: const InputDecoration(label: Text('难度')),
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
                      const SizedBox(height: 16.0),
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          '食材用料',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ..._materials.asMap().entries.map((entry) {
                        return MaterialInput(
                          material: entry.value,
                          onSubmit: (v) {
                            setState(() {
                              _materials[entry.key] = v;
                            });
                          },
                          onDelete: () {
                            setState(() {
                              _materials.removeAt(entry.key);
                            });
                          },
                        );
                      }),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _materials.add(MenuMaterial(name: ''));
                            });
                          },
                          child: const Text('添加食材'),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          '菜单步骤',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ..._stepControllers.asMap().entries.map(
                            (step) => Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: TextFormField(
                                      controller: step.value,
                                      minLines: 2,
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                        label: Text('步骤${step.key + 1}'),
                                        hintText: '请输入步骤内容',
                                      ),
                                      validator: (v) =>
                                          v!.trim().isEmpty ? '步骤内容不能为空' : null,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('删除步骤'),
                                            content: const Text(
                                                '删除当前步骤后,之前输入的步骤内容将丢失,是否确定?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('取消'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _stepControllers
                                                        .removeAt(step.key);
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('确定'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _stepControllers.add(TextEditingController());
                            });
                          },
                          child: const Text('添加步骤'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// 提交按钮
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
                              type: _type,
                              remark: _remarkController.text,
                              createdAt: widget.menu?.createdAt ??
                                  DateTime.now().millisecondsSinceEpoch,
                              updatedAt: DateTime.now().millisecondsSinceEpoch,
                              thumbnail: _imagePath,
                              materials: _materials,
                              steps:
                                  _stepControllers.map((c) => c.text).toList(),
                            );
                            await MenuHelper.update(newMenu);
                          } else {
                            var newMenu = Menu(
                              name: _nameController.text,
                              level: _level,
                              type: _type,
                              remark: _remarkController.text,
                              createdAt: DateTime.now().millisecondsSinceEpoch,
                              updatedAt: DateTime.now().millisecondsSinceEpoch,
                              thumbnail: _imagePath,
                              materials: _materials,
                              steps:
                                  _stepControllers.map((c) => c.text).toList(),
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
