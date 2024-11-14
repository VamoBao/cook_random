import 'package:cook_random/common/IngredientHelper.dart';
import 'package:cook_random/common/InventoryHelper.dart';
import 'package:cook_random/model/Ingredient.dart';
import 'package:cook_random/model/Inventory.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InventoryDetail extends StatefulWidget {
  const InventoryDetail({this.inventory, super.key});

  final Inventory? inventory;

  @override
  State<InventoryDetail> createState() => _InventoryDetailState();
}

class _InventoryDetailState extends State<InventoryDetail> {
  final GlobalKey _form = GlobalKey<FormState>();
  late List<Ingredient> _ingredients = [];
  StorageWay _storageWay = StorageWay.refrigerate;
  final TextEditingController _dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  final TextEditingController _ingredientController = TextEditingController();
  late int _ingredientId;

  _loadIngredients() async {
    var res = await IngredientHelper.getList();
    setState(() {
      _ingredients = res;
    });
  }

  @override
  void initState() {
    // 获取食材列表
    _loadIngredients();
    if (widget.inventory != null) {
      _storageWay = widget.inventory!.storageWay;
      _ingredientController.text = widget.inventory?.ingredientName ?? '';
      _dateController.text = DateFormat('yyyy-MM-dd').format(
          DateTime.fromMillisecondsSinceEpoch(widget.inventory!.storageTime));
      _ingredientId = widget.inventory!.ingredientsId;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.inventory == null ? '编辑' : '新增'),
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
                    DropdownButtonFormField(
                      value: _storageWay,
                      items: StorageWay.values
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e.label)))
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          _storageWay = v!;
                        });
                      },
                      decoration: const InputDecoration(
                        label: Text('保存方式'),
                        hintText: '请选择保存方式',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      readOnly: true,
                      controller: _dateController,
                      decoration: const InputDecoration(
                        label: Text('入库时间'),
                      ),
                      onTap: () async {
                        var picker = await showDatePicker(
                          context: context,
                          locale: const Locale('zh'),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picker != null) {
                          _dateController.text =
                              DateFormat('yyyy-MM-dd').format(picker);
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _ingredientController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        label: Text('食材'),
                        hintText: '点击选择食材',
                      ),
                      validator: (v) => v!.trim().isEmpty ? '食材不能为空' : null,
                      onTap: () async {
                        var res = await showDialog<Ingredient>(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: const Text('选择食材'),
                              children: _ingredients
                                  .map((o) => SimpleDialogOption(
                                        child: Text(o.name),
                                        onPressed: () {
                                          Navigator.pop(context, o);
                                        },
                                      ))
                                  .toList(),
                            );
                          },
                        );
                        if (res != null) {
                          _ingredientController.text = res.name;
                          setState(() {
                            _ingredientId = res.id ?? 0;
                          });
                        }
                      },
                    )
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
                          if (widget.inventory != null) {
                            var newInventory = Inventory(
                              id: widget.inventory?.id,
                              ingredientsId: _ingredientId,
                              storageTime: DateTime.parse(_dateController.text)
                                  .millisecondsSinceEpoch,
                              storageWay: _storageWay,
                              createdAt: widget.inventory?.createdAt ??
                                  DateTime.now().millisecondsSinceEpoch,
                              updatedAt: DateTime.now().millisecondsSinceEpoch,
                            );
                            await InventoryHelper.update(newInventory);
                          } else {
                            var newInventory = Inventory(
                              ingredientsId: _ingredientId,
                              storageTime: DateTime.parse(_dateController.text)
                                  .millisecondsSinceEpoch,
                              storageWay: _storageWay,
                              createdAt: DateTime.now().millisecondsSinceEpoch,
                              updatedAt: DateTime.now().millisecondsSinceEpoch,
                            );
                            await InventoryHelper.insert(newInventory);
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
