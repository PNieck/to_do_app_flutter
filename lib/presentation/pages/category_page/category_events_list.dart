import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:to_do_app_flutter/data/models/base_calendar_events.dart';
import 'package:to_do_app_flutter/data/models/calendar_event.dart';
import 'package:to_do_app_flutter/data/models/event_category.dart';
import 'package:to_do_app_flutter/presentation/elements/normal_event_tile.dart';

class CategoryEventsList extends StatelessWidget {
  final List<BaseCalendarEvent> events;
  final EventCategory category;

  const CategoryEventsList(
      {required this.events, required this.category, super.key});

  static const Widget stdSeparator = Divider();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              constraints: const BoxConstraints(minWidth: double.infinity),
              margin: const EdgeInsets.all(10),
              child: Text(category.name,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            stdSeparator,
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) => NormalEventTile(
                      event: events[index],
                      redirectUrl:
                          "/category/${category.id}/event/${events[index].id}"),
                  separatorBuilder: (context, index) => stdSeparator,
                  itemCount: events.length),
            )
          ],
        ),
      ],
    );
  }
}
