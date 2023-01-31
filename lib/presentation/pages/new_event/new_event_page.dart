import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_flutter/logic/cubit/events/single_event_cubit.dart';
import 'package:to_do_app_flutter/logic/cubit/login/login_cubit.dart';
import 'package:to_do_app_flutter/presentation/pages/new_event/builder.dart';

class NewEventPage extends StatelessWidget {
  const NewEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SingleEventCubit(context.read<LoginCubit>()),
      child: const NewEventPageBuilder(),
    );
  }
}
