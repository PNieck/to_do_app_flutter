import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:to_do_app_flutter/Helpers/date_time.dart';

import '../../../data/models/base_calendar_events.dart';
import '../../elements/normal_event_tile.dart';

class TodayReadyPage extends StatefulWidget {
  final List<BaseCalendarEvent> events;
  const TodayReadyPage(this.events, {super.key});

  @override
  State<TodayReadyPage> createState() => _TodayReadyPageState();
}

class _TodayReadyPageState extends State<TodayReadyPage> {
  static const highlightColor = Color.fromARGB(255, 225, 0, 0);
  final stdSeparator = const SizedBox(height: 7);
  DateTime nowDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final events = widget.events;

    return Stack(children: [
      Column(
        children: [
          Container(
            constraints: const BoxConstraints(minWidth: double.infinity),
            margin: const EdgeInsets.all(10),
            child: const Text("Today:",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                )),
          ),
          firstSeparator(),
          TimerBuilder.periodic(
            const Duration(minutes: 1),
            builder: (context) {
              nowDateTime = DateTime.now();
              return ListView.separated(
                shrinkWrap: true,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];

                  if (event.isNow()) {
                    return actualEventTile(event);
                  }
                  return NormalEventTile(
                    event: event,
                    redirectUrl: "/event/${event.id}",
                  );
                },
                separatorBuilder: createSeparator,
              );
            },
          ),
          lastSeparator(),
        ],
      ),
      Positioned(
        bottom: 20,
        right: 20,
        child: FloatingActionButton(
          onPressed: () {
            context.go("/new_event");
          },
          child: const Icon(Icons.add),
        ),
      ),
    ]);
  }

  Widget createSeparator(context, index) {
    if (nowDateTime.isAfter(widget.events[index].endTime()) &&
        nowDateTime.isBefore(widget.events[index + 1].startDateTime)) {
      return actualMomentIndicator();
    }

    return stdSeparator;
  }

  Widget firstSeparator() {
    if (widget.events.isNotEmpty &&
        nowDateTime.isBefore(widget.events[0].startDateTime)) {
      return actualMomentIndicator();
    }

    return stdSeparator;
  }

  Widget lastSeparator() {
    if (widget.events.isNotEmpty &&
        nowDateTime.isAfter(widget.events.last.endTime())) {
      return actualMomentIndicator();
    }

    return stdSeparator;
  }

  Widget actualMomentIndicator() {
    return Stack(
      alignment: AlignmentDirectional.centerStart,
      children: [
        const Divider(
          color: highlightColor,
          thickness: 3,
          height: 27,
        ),
        Positioned(
          left: 9,
          child: Container(
            constraints: BoxConstraints.tight(const Size(35, 20)),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: highlightColor,
            ),
            alignment: Alignment.center,
            child: Text(
              TimeOfDay.fromDateTime(nowDateTime).format(context),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget actualEventTile(BaseCalendarEvent event) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(children: [
        Material(
          elevation: 10,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: Container(
            height: 75,
            width: 350,
            decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                border: Border.all(color: highlightColor, width: 3)),
            child: ListTile(
              title: Text(event.name),
              onTap: () => context.push("/event/${event.id}"),
              subtitle: Text(
                  "${event.startDateTime.formatTime()} - ${event.endTime().formatTime()}"),
            ),
          ),
        ),
        Container(
          constraints: BoxConstraints.tight(const Size(35, 20)),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(5),
              topLeft: Radius.circular(15),
            ),
            color: highlightColor,
          ),
          alignment: Alignment.center,
          child: Text(
            nowDateTime.formatTime(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        )
      ]),
    );
  }
}
