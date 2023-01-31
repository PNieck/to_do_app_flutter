import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/event_category.dart';
import '../../../logic/cubit/categories/categories_cubit.dart';
import '../app_text_form_field.dart';

class RenameCategory extends StatefulWidget {
  final EventCategory category;

  const RenameCategory({required this.category, super.key});

  @override
  State<RenameCategory> createState() => _RenameCategoryState();
}

class _RenameCategoryState extends State<RenameCategory> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = widget.category.name;

    return SimpleDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      title: const Text("Rename category"),
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              AppTextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Category name cannot be empty';
                  }
                  return null;
                },
                controller: nameController,
                labelText: 'New category name',
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.category.name = nameController.text;
                    context
                        .read<CategoriesCubit>()
                        .updateCategory(widget.category);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Ok'),
              ),
            ],
          ),
        )
      ],
    );
  }
}
