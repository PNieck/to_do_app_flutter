import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_flutter/data/models/event_category.dart';

import '../../../logic/cubit/categories/categories_cubit.dart';
import '../app_text_form_field.dart';

class AddCategoryPopUp extends StatefulWidget {
  const AddCategoryPopUp({super.key});

  @override
  State<AddCategoryPopUp> createState() => _AddCategoryPopUpState();
}

class _AddCategoryPopUpState extends State<AddCategoryPopUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      title: const Text("Add new category"),
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
                labelText: "Category name",
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<CategoriesCubit>().createCategory(
                        EventCategory(name: nameController.text));
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
    ;
  }
}
