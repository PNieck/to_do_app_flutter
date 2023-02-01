import 'package:to_do_app_flutter/data/models/base_calendar_events.dart';
import 'package:to_do_app_flutter/data/models/calendar_event.dart';
import 'package:to_do_app_flutter/data/models/event_category.dart';
import 'package:to_do_app_flutter/data/models/user.dart';
import 'package:to_do_app_flutter/data/providers/firebase_categories_provider.dart';
import 'package:to_do_app_flutter/data/repositories/events_repository.dart';
import 'package:tuple/tuple.dart';

class CategoriesRepository {
  final AppUser user;
  final FirebaseCategoriesProvider provider;

  CategoriesRepository(this.user) : provider = FirebaseCategoriesProvider(user);

  Future<List<EventCategory>> readCategories() async {
    List<Map<String, Object>> rawData = await provider.getCategories();

    List<EventCategory> result = [];

    for (var data in rawData) {
      result.add(EventCategory.deserialize(data));
    }

    return result;
  }

  Future<EventCategory> readSingleCategory(String categoryID) async {
    Map<String, dynamic> rawData = await provider.getSingleCategory(categoryID);

    return EventCategory.deserialize(rawData);
  }

  Future<void> createCategory(EventCategory newCategory) async {
    Map<String, Object> data = newCategory.serialize();

    await provider.createCategory(data);
  }

  Future<void> updateCategory(EventCategory category) async {
    Map<String, Object> data = category.serialize();

    await provider.updateCategory(data);
  }

  Future<void> deleteCategory(String categoryID) async {
    EventsRepository eventsRepo = EventsRepository(user);

    Tuple2<List<BaseCalendarEvent>, EventCategory> events =
        await eventsRepo.readCategoryEvents(categoryID);

    if (events.item1.isNotEmpty) {
      List<Future<void>> jobs = <Future<void>>[];
      for (var event in events.item1) {
        event.category = null;
        jobs.add(eventsRepo.updateBaseEvent(event));
      }

      await Future.wait(jobs);
    }

    provider.deleteCategory(categoryID);
  }
}
