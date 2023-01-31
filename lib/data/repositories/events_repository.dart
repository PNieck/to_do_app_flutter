import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app_flutter/data/models/base_calendar_events.dart';
import 'package:to_do_app_flutter/data/models/event_category.dart';
import 'package:to_do_app_flutter/data/providers/firebase_events_provider.dart';
import 'package:to_do_app_flutter/data/repositories/categories_repository.dart';
import 'package:tuple/tuple.dart';

import '../models/calendar_event.dart';
import '../models/user.dart';

class EventsRepository {
  final AppUser user;
  late final FirebaseEventsProvider provider;

  EventsRepository(this.user) {
    provider = FirebaseEventsProvider(user: user);
  }

  Future<void> createEvent(CalendarEvent newEvent) async {
    Map<String, dynamic> data = newEvent.serialize();
    Map<String, dynamic> additionalData = {"description": data["description"]};
    data.remove("description");

    await provider.createEvent(data, additionalData);
  }

  Future<void> deleteEvent(String eventID) async {
    await provider.deleteEvent(eventID);
  }

  Future<List<BaseCalendarEvent>> readEventsFromDay(DateTime day) async {
    List<Map<String, dynamic>> dataList = await provider.getDayEvents(day);

    return _deserializeRawData(dataList);
  }

  Future<List<BaseCalendarEvent>> readEventsFromDateRange(
      DateTime startDate, DateTime endDate) async {
    List<Map<String, dynamic>> rawData =
        await provider.getEventsFromDateRange(startDate, endDate);

    return _deserializeRawData(rawData);
  }

  Future<CalendarEvent> readEvent(String eventId) async {
    Map<String, dynamic> rawData = await provider.readEvent(eventId);

    return CalendarEvent.deserialize(rawData);
  }

  Future<Tuple2<List<BaseCalendarEvent>, EventCategory>> readCategoryEvents(
      String categoryID) async {
    List<Map<String, dynamic>> rawData =
        await provider.getCategoryEvents(categoryID);

    List<BaseCalendarEvent> events = _deserializeRawData(rawData);

    EventCategory category;
    if (events.isEmpty) {
      CategoriesRepository categoriesRepo = CategoriesRepository(user);

      category = await categoriesRepo.readSingleCategory(categoryID);
    } else {
      category = events.first.category!;
    }

    return Tuple2(events, category);
  }

  List<BaseCalendarEvent> _deserializeRawData(
      List<Map<String, dynamic>> rawData) {
    return List.generate(rawData.length,
        (index) => BaseCalendarEvent.deserialize(rawData[index]));
  }
}
