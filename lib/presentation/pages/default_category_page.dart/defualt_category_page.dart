import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_flutter/logic/cubit/events/events_collections_cubit.dart';
import 'package:to_do_app_flutter/logic/cubit/login/login_cubit.dart';
import 'package:to_do_app_flutter/presentation/pages/default_category_page.dart/builder.dart';

class DefaultCategoryPage extends StatelessWidget {
  const DefaultCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventsCollectionsCubit(context.read<LoginCubit>()),
      child: const DefaultCategoryPageBuilder(),
    );
  }
}
