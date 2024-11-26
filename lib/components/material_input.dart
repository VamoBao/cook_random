import 'dart:async';

import 'package:cook_random/model/Menu.dart';
import 'package:flutter/material.dart';

class MaterialInput extends StatefulWidget {
  const MaterialInput({
    this.material,
    required this.onSubmit,
    required this.onDelete,
    super.key,
  });

  final MenuMaterial? material;
  final void Function(MenuMaterial material) onSubmit;
  final void Function() onDelete;

  @override
  State<MaterialInput> createState() => _MaterialInputState();
}

class _MaterialInputState extends State<MaterialInput> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  Timer? _debounce;

  void _onTextChange(String v) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        widget.onSubmit(MenuMaterial(
          name: _nameController.text,
          unit: _unitController.text,
        ));
      },
    );
  }

  @override
  void initState() {
    if (widget.material != null) {
      _nameController.text = widget.material!.name;
      _unitController.text = widget.material?.unit ?? '';
    }
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: TextFormField(
              controller: _nameController,
              validator: (v) => v!.trim().isEmpty ? '食材名不能为空' : null,
              decoration: const InputDecoration(
                label: Text('食材'),
                hintText: '请输入名称',
              ),
              onChanged: _onTextChange,
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            flex: 1,
            child: TextFormField(
              controller: _unitController,
              decoration: const InputDecoration(
                label: Text('用量'),
                hintText: '请输入用量',
              ),
              onChanged: _onTextChange,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
              onPressed: widget.onDelete,
              icon: Icon(
                Icons.cancel,
                color: Theme.of(context).colorScheme.error,
              ))
        ],
      ),
    );
  }
}
