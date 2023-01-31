import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_app_flutter/Helpers/date_time.dart';
import 'package:to_do_app_flutter/data/models/calendar_event.dart';
import 'package:to_do_app_flutter/logic/cubit/events/single_event_cubit.dart';
import 'package:to_do_app_flutter/logic/cubit/login/login_cubit.dart';
import 'package:to_do_app_flutter/presentation/pages/single_event/delete_event_pop_up.dart';

class DisplaySingleEvent extends StatefulWidget {
  final CalendarEvent event;

  const DisplaySingleEvent({required this.event, super.key});

  @override
  State<DisplaySingleEvent> createState() => _DisplaySingleEventState();
}

class _DisplaySingleEventState extends State<DisplaySingleEvent> {
  @override
  Widget build(BuildContext context) {
    const stdDivider = Divider();

    return Scaffold(
      body: Stack(children: [
        ListView(
          children: [
            Container(
              constraints: const BoxConstraints(minWidth: double.infinity),
              margin: const EdgeInsets.all(10),
              child: Text(widget.event.name,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            stdDivider,
            ListTile(
              leading: const Icon(Icons.schedule),
              title: Table(
                defaultColumnWidth: const IntrinsicColumnWidth(),
                children: [
                  TableRow(children: [
                    const Text("From:"),
                    Text(widget.event.startDateTime.getWeekDayName()),
                    Text(widget.event.startDateTime.formatDateAndTime()),
                  ]),
                  TableRow(children: [
                    const Text("To:"),
                    Text(widget.event.endTime().getWeekDayName()),
                    Text(widget.event.endTime().formatDateAndTime())
                  ])
                ],
              ),
            ),
            stdDivider,
            ListTile(
              leading: const Icon(Icons.category),
              title: Text(widget.event.category == null
                  ? "Default"
                  : widget.event.category!.name),
            ),
            stdDivider,
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text("Description:"),
              subtitle: Builder(
                builder: (context) {
                  if (widget.event.description != null) {
                    return Text(widget.event.description!);
                  }
                  return const Text("/* no description */");
                },
              ),
            ),
            stdDivider,
          ],
        ),
        Positioned(
          bottom: 90,
          right: 20,
          child: FloatingActionButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (newContext) => BlocProvider.value(
                  value: context.read<LoginCubit>(),
                  child: BlocProvider(
                    create: (context) =>
                        SingleEventCubit(context.read<LoginCubit>()),
                    child: DeleteEventPopUp(event: widget.event),
                  ),
                ),
              );
            },
            child: const Icon(Icons.delete),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.edit),
          ),
        ),
      ]),
    );
  }
}
