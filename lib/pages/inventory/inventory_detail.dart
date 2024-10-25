import 'package:cook_random/common/IngredientHelper.dart';
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

  _loadIngredients() async {
    var res = IngredientHelper.getList();
    setState(() {
      _ingredients = res;
    });
  }

  @override
  void initState() {
    // 获取食材列表
    _loadIngredients();
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
                          lastDate: DateTime(2100),
                        );
                        if (picker != null) {
                          _dateController.text =
                              DateFormat('yyyy-MM-dd').format(picker);
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
