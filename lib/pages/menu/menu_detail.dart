import 'package:cook_random/common/IngredientHelper.dart';
import 'package:cook_random/common/MenuHelper.dart';
import 'package:cook_random/components/image_picker.dart';
import 'package:cook_random/components/ingredients_select_list.dart';
import 'package:cook_random/model/Ingredient.dart';
import 'package:cook_random/model/Menu.dart';
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

  /// 难度选择list
  final List<String> _levelList = ['简单', '普通', '耗时'];

  /// 当前选择的难度
  int _level = 0;

  /// 是否主菜
  bool _isMain = true;

  /// 图片地址
  String? _imagePath;

  /// 步骤输入框controller集合
  List<TextEditingController> _stepControllers = [];

  List<int> _detailIngredients = [];

  /// 食材列表
  late List<Ingredient> _ingredients = [];

  _loadIngredients() async {
    var res = await IngredientHelper.getList();
    setState(() {
      _ingredients = res;
    });
  }

  @override
  void initState() {
    print(widget.menu?.toMap());
    // 进来获取一下食材
    _loadIngredients();
    // 如果menu不为空,表示是编辑状态
    if (widget.menu != null) {
      _nameController.text = widget.menu!.name;
      _remarkController.text = widget.menu!.remark ?? '';
      setState(() {
        _level = widget.menu!.level;
        _isMain = widget.menu!.isMain;
        _imagePath = widget.menu?.thumbnail;
        _detailIngredients = widget.menu?.ingredients ?? [];
        // 初始化步骤controller
        if (widget.menu?.steps?.length != 0) {
          _stepControllers = List.generate(
            widget.menu!.steps!.length,
            (index) => TextEditingController(
              text: widget.menu!.steps![index],
            ),
          );
        }
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
          padding: const EdgeInsets.symmetric(horizontal: 32),
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
                        contentPadding:
                            const EdgeInsets.only(left: 0, right: 0),
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
                      const SizedBox(height: 16.0),
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          '食材材料',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          spacing: 8,
                          children: [
                            ..._detailIngredients.map((id) {
                              final current =
                                  _ingredients.firstWhere((ingredient) {
                                return ingredient.id == id;
                              });
                              return InputChip(
                                label: Text(current.name ?? ''),
                                onDeleted: () {
                                  setState(() {
                                    _detailIngredients.remove(id);
                                  });
                                },
                              );
                            }),
                            FilledButton.tonal(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setModalState) {
                                          return Column(
                                            children: [
                                              const Text(
                                                '选择食材',
                                                style: TextStyle(
                                                    fontSize: 20, height: 2),
                                              ),
                                              IngredientsSelectList(
                                                selectedKeys:
                                                    _detailIngredients,
                                                ingredients: _ingredients,
                                                onSelect: (id, select) {
                                                  setState(() {
                                                    select
                                                        ? _detailIngredients
                                                            .add(id)
                                                        : _detailIngredients
                                                            .remove(id);
                                                  });
                                                  setModalState(() {});
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    });
                              },
                              child: const Text('添加食材'),
                            )
                          ],
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
                      )
                    ],
                  ),
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
                              thumbnail: _imagePath,
                              ingredients: _detailIngredients,
                              steps:
                                  _stepControllers.map((c) => c.text).toList(),
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
                              thumbnail: _imagePath,
                              ingredients: _detailIngredients,
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
