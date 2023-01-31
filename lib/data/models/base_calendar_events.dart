import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app_flutter/data/models/calendar_event.dart';
import 'package:to_do_app_flutter/data/models/event_category.dart';

class BaseCalendarEvent {
  final String id;

  String name;
  DateTime startDateTime;
  Duration duration;
  EventCategory? category;

  BaseCalendarEvent({
    required this.name,
    required this.startDateTime,
    required this.duration,
    this.category,
    this.id = '',
  }) {
    if (name == '') {
      throw ArgumentError("Event had empty name");
    }
    if (duration.isNegative) {
      throw ArgumentError("Duration of an event cannot be negative");
    }
  }

  DateTime endTime() {
    return startDateTime.add(duration);
  }

  bool isNow() {
    Duration difference = DateTime.now().difference(startDateTime);

    if (!difference.isNegative && difference.compareTo(duration) <= 0) {
      return true;
    }

    return false;
  }

  Map<String, dynamic> serialize() {
    return {
      "id": id,
      "name": name,
      "startDateTime": startDateTime,
      "duration": duration.inSeconds,
      "category": category?.serialize(),
    };
  }

  BaseCalendarEvent.deserialize(Map<String, dynamic> data)
      : id = data["id"],
        name = data["name"],
        startDateTime = (data["startDateTime"] as Timestamp).toDate(),
        duration = Duration(seconds: data["duration"]),
        category = data["category"] == null
            ? null
            : EventCategory.deserialize(data["category"]);
}
