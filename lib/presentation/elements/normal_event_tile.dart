import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_app_flutter/Helpers/date_time.dart';
import 'package:to_do_app_flutter/data/models/base_calendar_events.dart';
import 'package:to_do_app_flutter/data/models/calendar_event.dart';

class NormalEventTile extends StatelessWidget {
  final BaseCalendarEvent event;
  final String redirectUrl;

  const NormalEventTile(
      {required this.event, required this.redirectUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      constraints: BoxConstraints.tight(const Size(350, 75)),
      child: ListTile(
        title: Text(event.name),
        subtitle: Text(
            "${event.startDateTime.formatTime()} - ${event.endTime().formatTime()}"),
        tileColor: Colors.yellow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onTap: () => context.go("/event/${event.id}"),
      ),
    );
  }
}
