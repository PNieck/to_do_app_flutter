import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_flutter/data/models/event_category.dart';
import 'package:to_do_app_flutter/logic/cubit/categories/categories_cubit.dart';

class CategoryChooseMenu extends StatefulWidget {
  const CategoryChooseMenu({super.key});

  @override
  State<CategoryChooseMenu> createState() => _CategoryChooseMenuState();
}

class _CategoryChooseMenuState extends State<CategoryChooseMenu> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<CategoriesCubit>(),
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          if (state is CategoriesReady) {
            return CategoriesLoaded(categories: state.categories);
          }
          if (state is CategoriesLoading) {
            return const WaitingPopUp();
          }
          if (state is CategoriesError) {
            return const ErrorPopUp();
          } else {
            context.read<CategoriesCubit>().readCategories();
            return const WaitingPopUp();
          }
        },
      ),
    );
  }
}

class CategoriesLoaded extends StatelessWidget {
  final List<EventCategory> categories;
  const CategoriesLoaded({required this.categories, super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Choose category"),
      children: [
        Container(
          constraints: const BoxConstraints(maxHeight: 400, maxWidth: 300),
          child: ListView.builder(
            itemCount: categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return SimpleDialogOption(
                  child: const Text("Default"),
                  onPressed: () => Navigator.pop(context, null),
                );
              }

              return SimpleDialogOption(
                child: Text(categories[index - 1].name),
                onPressed: () => Navigator.pop(context, categories[index - 1]),
              );
            },
          ),
        )
      ],
    );
  }
}

class WaitingPopUp extends StatelessWidget {
  const WaitingPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(
              height: 15,
            ),
            Text('Loading...')
          ],
        ),
      ),
    );
  }
}

class ErrorPopUp extends StatelessWidget {
  const ErrorPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text("Something gone wrong..."),
      content: Text("An error occurred. Try again later"),
    );
  }
}
