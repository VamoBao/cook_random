import 'package:cook_random/model/Ingredient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IngredientDetail extends StatefulWidget {
  const IngredientDetail({this.ingredient, super.key});

  final Ingredient? ingredient;

  @override
  State<IngredientDetail> createState() => _IngredientDetailState();
}

class _IngredientDetailState extends State<IngredientDetail> {
  final GlobalKey _form = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _shelfLifeController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  IngredientType _type = IngredientType.vegetable;
  StorageWay _way = StorageWay.refrigerate;

  @override
  void initState() {
    if (widget.ingredient != null) {
      _nameController.text = widget.ingredient!.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ingredient == null ? '新增食材' : '编辑食材'),
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          label: Text('食材名称'),
                          hintText: '请输入食材名称',
                        ),
                        validator: (v) => v!.trim().isEmpty ? '食材名称不能为空' : null,
                      ),
                      const SizedBox(height: 16.0),
                      DropdownButtonFormField(
                        value: _type,
                        items: IngredientType.values
                            .map((e) => DropdownMenuItem(
                                value: e, child: Text(e.label)))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            _type = v!;
                          });
                        },
                        decoration: const InputDecoration(
                          label: Text('食材类别'),
                          hintText: '请选择食材类别',
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _shelfLifeController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          label: Text('保质期'),
                          hintText: '请输入保质期',
                        ),
                        validator: (v) {
                          int? value = int.tryParse(v!.trim());
                          if (value != null) {
                            return value > 0 ? null : '请输入正确的保质期天数';
                          } else {
                            return '必须输入整数';
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      DropdownButtonFormField(
                        value: _way,
                        items: StorageWay.values
                            .map((e) => DropdownMenuItem(
                                value: e, child: Text(e.label)))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            _way = v!;
                          });
                        },
                        decoration: const InputDecoration(
                          label: Text('推荐储存方式'),
                          hintText: '请选择推荐保存方式',
                        ),
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
              ),
              Container(
                padding: const EdgeInsets.only(top: 16.0),
                width: double.infinity,
                child: Builder(
                  builder: (context) {
                    return FilledButton(
                      onPressed: () {},
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
