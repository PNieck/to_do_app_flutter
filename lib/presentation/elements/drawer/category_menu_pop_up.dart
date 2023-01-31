import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_flutter/data/models/event_category.dart';

import '../../../logic/cubit/categories/categories_cubit.dart';
import '../app_text_form_field.dart';

enum CategoryMenuResult {
  rename,
  delete,
  nothing,
}

class CategoryMenuPopUp extends StatefulWidget {
  final EventCategory category;

  const CategoryMenuPopUp({required this.category, super.key});

  @override
  State<CategoryMenuPopUp> createState() => _CategoryMenuPopUpState();
}

class _CategoryMenuPopUpState extends State<CategoryMenuPopUp> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      title: Text("${widget.category.name} category"),
      children: [
        SimpleDialogOption(
          //padding: const EdgeInsets.symmetric(horizontal: 2),
          child: const Text("Rename"),
          onPressed: () {
            Navigator.pop(context, CategoryMenuResult.rename);
          },
        ),
        SimpleDialogOption(
          child: const Text("Delete"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
