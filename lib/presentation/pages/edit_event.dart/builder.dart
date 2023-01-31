import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_app_flutter/logic/cubit/events/events_change_cubit.dart';
import 'package:to_do_app_flutter/logic/cubit/events/single_event_cubit.dart';
import 'package:to_do_app_flutter/presentation/pages/edit_event.dart/edit_form.dart';
import 'package:to_do_app_flutter/presentation/pages/error_page.dart';
import 'package:to_do_app_flutter/presentation/pages/loading_page.dart';

class EditPageBuilder extends StatefulWidget {
  final String eventID;
  const EditPageBuilder({required this.eventID, super.key});

  @override
  State<EditPageBuilder> createState() => _EditPageBuilderState();
}

class _EditPageBuilderState extends State<EditPageBuilder> {
  @override
  void initState() {
    super.initState();

    context.read<SingleEventCubit>().readSingleEvent(widget.eventID);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SingleEventCubit, SingleEventState>(
      listener: (context, state) {
        if (state is SingleEventUpdatedSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Event updated successfully.")));
          context.pop();
        }
      },
      builder: (context, state) {
        if (state is SingleEventInitial || state is SingleEventLoading) {
          return const LoadingPage();
        }

        if (state is SingleEventReady) {
          return EditEventForm(initEvent: state.event);
        }

        if (state is SingleEventError) {
          return ErrorPage(errorMessage: state.toString());
        }

        return const ErrorPage(
          errorMessage: "Unknown error occurred",
        );
      },
    );
  }
}
