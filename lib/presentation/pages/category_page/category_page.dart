import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_flutter/logic/cubit/events/events_collections_cubit.dart';
import 'package:to_do_app_flutter/logic/cubit/login/login_cubit.dart';
import 'package:to_do_app_flutter/presentation/pages/category_page/builder.dart';

class CategoryPage extends StatelessWidget {
  final String categoryID;

  const CategoryPage({required this.categoryID, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventsCollectionsCubit(context.read<LoginCubit>()),
      child: CategoryPageBuilder(categoryID: categoryID),
    );
  }
}
