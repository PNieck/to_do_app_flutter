import 'package:to_do_app_flutter/data/models/base_calendar_events.dart';
import 'package:to_do_app_flutter/data/models/event_category.dart';

class CalendarEvent extends BaseCalendarEvent {
  String? description;

  CalendarEvent({
    required name,
    required startDateTime,
    required duration,
    EventCategory? category,
    String id = '',
    this.description,
  }) : super(
          name: name,
          startDateTime: startDateTime,
          duration: duration,
          category: category,
          id: id,
        );

  @override
  Map<String, dynamic> serialize() {
    Map<String, dynamic> result = super.serialize();
    result["description"] = description;

    return result;
  }

  CalendarEvent.deserialize(Map<String, dynamic> data)
      : description = data["description"],
        super.deserialize(data);
}
