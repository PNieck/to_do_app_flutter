import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_app_flutter/data/models/calendar_event.dart';

import '../../../logic/cubit/events/single_event_cubit.dart';

class DeleteEventPopUp extends StatefulWidget {
  final CalendarEvent event;
  const DeleteEventPopUp({required this.event, super.key});

  @override
  State<DeleteEventPopUp> createState() => _DeleteEventPopUpState();
}

class _DeleteEventPopUpState extends State<DeleteEventPopUp> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SingleEventCubit, SingleEventState>(
      listener: (context, state) {
        if (state is SingleEventDeletedSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Event was deleted.")));
          context.pop();
          context.pop();
        }
      },
      builder: (context, state) {
        if (state is SingleEventInitial) {
          return AlertDialog(
            title: const Text('Alert Dialog'),
            content: const Text('Do you really want to delete?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    await context
                        .read<SingleEventCubit>()
                        .deleteEvent(widget.event.id);
                  },
                  child: const Text('Yes')),
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        }

        if (state is SingleEventLoading) {
          return SimpleDialog(
            title: const Text("Loading"),
            children: [
              Container(
                constraints: BoxConstraints.tight(const Size(100, 100)),
                child: const CircularProgressIndicator(),
              ),
            ],
          );
        }

        if (state is SingleEventDeletedSuccessfully) {
          return const SimpleDialog();
        }

        return AlertDialog(
          title: const Text("Sorry, an error occurred"),
          actions: [
            TextButton(
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
                child: const Text("Close")),
          ],
        );
      },
    );
  }
}
