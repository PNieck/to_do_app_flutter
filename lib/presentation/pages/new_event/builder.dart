import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_app_flutter/logic/cubit/events/single_event_cubit.dart';
import 'package:to_do_app_flutter/presentation/pages/error_page.dart';
import 'package:to_do_app_flutter/presentation/pages/loading_page.dart';
import 'package:to_do_app_flutter/presentation/pages/new_event/creating_page.dart';

class NewEventPageBuilder extends StatefulWidget {
  const NewEventPageBuilder({super.key});

  @override
  State<NewEventPageBuilder> createState() => _NewEventPageBuilderState();
}

class _NewEventPageBuilderState extends State<NewEventPageBuilder> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SingleEventCubit, SingleEventState>(
        listener: (context, state) {
      if (state is SingleEventCreatedSuccessfully) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Event created successfully.")));
        context.pop();
      }
    }, builder: (context, state) {
      if (state is SingleEventInitial) {
        return const CreatingEventPage();
      }

      if (state is SingleEventLoading) {
        return const LoadingPage();
      }

      if (state is SingleEventError) {
        return ErrorPage(
          errorMessage: state.toString(),
        );
      }

      return const ErrorPage(
        errorMessage: "Unknown error",
      );
    });
  }
}
