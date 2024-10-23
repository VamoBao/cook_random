import 'package:cook_random/model/Ingredient.dart';
import 'package:flutter/material.dart';

class IngredientDetail extends StatefulWidget {
  const IngredientDetail({this.ingredient, super.key});

  final Ingredient? ingredient;

  @override
  State<IngredientDetail> createState() => _IngredientDetailState();
}

class _IngredientDetailState extends State<IngredientDetail> {
  final GlobalKey _form = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

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
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        label: Text('食材名称'),
                        hintText: '请输入食材名称',
                      ),
                      validator: (v) => v!.trim().isEmpty ? '食材名称不能为空' : null,
                    )
                  ],
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
