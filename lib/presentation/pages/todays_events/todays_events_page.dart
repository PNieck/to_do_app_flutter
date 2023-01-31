import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_flutter/logic/cubit/events/events_collections_cubit.dart';
import 'package:to_do_app_flutter/logic/cubit/login/login_cubit.dart';
import 'package:to_do_app_flutter/presentation/pages/todays_events/builder.dart';

class TodaysEventsPage extends StatelessWidget {
  const TodaysEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventsCollectionsCubit(context.read<LoginCubit>()),
      child: const TodaysPageBuilder(),
    );
  }
}
