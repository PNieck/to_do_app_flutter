import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AppTextFormField extends TextFormField {
  AppTextFormField({
    super.key,
    super.keyboardType,
    super.controller,
    super.validator,
    super.maxLines,
    String? labelText,
  }) : super(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: labelText,
          ),
        );
}
