part of 'events_collections_cubit.dart';

@immutable
abstract class EventsCollectionsState {}

class EventsCollectionsInitial extends EventsCollectionsState {}

class EventsCollectionLoading extends EventsCollectionsState {}

class EventsCollectionReady extends EventsCollectionsState {
  final List<BaseCalendarEvent> events;
  final EventsCollectionType collectionType;

  EventsCollectionReady(this.events, this.collectionType);
}

class EventsCollectionsError extends EventsCollectionsState {
  final String? errorMsg;

  EventsCollectionsError({this.errorMsg});

  @override
  String toString() {
    if (errorMsg == null) {
      return "Events collection error";
    }

    return errorMsg!;
  }
}

@immutable
abstract class EventsCollectionType {}

class DayCollectionType extends EventsCollectionType {
  final DateTime day;

  DayCollectionType(this.day);
}

class DateRangeCollectionType extends EventsCollectionType {
  final DateTime startDate;
  final DateTime endDate;

  DateRangeCollectionType(this.startDate, this.endDate);
}

class CategoryCollectionType extends EventsCollectionType {
  final EventCategory category;

  CategoryCollectionType(this.category);
}
