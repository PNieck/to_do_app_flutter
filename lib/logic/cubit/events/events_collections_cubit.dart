import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:to_do_app_flutter/data/models/event_category.dart';
import 'package:to_do_app_flutter/data/repositories/events_repository.dart';
import 'package:to_do_app_flutter/logic/cubit/login/login_cubit.dart';
import 'package:tuple/tuple.dart';

import '../../../data/models/base_calendar_events.dart';

part 'events_collections_state.dart';

class EventsCollectionsCubit extends Cubit<EventsCollectionsState> {
  final LoginCubit _loginCubit;
  late final StreamSubscription _loginSubscription;

  EventsRepository? eventsRepository;

  EventsCollectionsCubit(this._loginCubit) : super(EventsCollectionsInitial()) {
    _loginSubscription = _loginCubit.stream.listen((state) {
      if (state is LoggedIn) {
        eventsRepository = EventsRepository(state.user);
        return;
      }

      eventsRepository = null;
      emit(EventsCollectionsError(
          errorMsg: "Cannot fetch data - user not logged in."));
    });

    LoginState loginState = _loginCubit.state;
    if (loginState is LoggedIn) {
      eventsRepository = EventsRepository(loginState.user);
    }
  }

  Future<void> readEventsFromCategory(String categoryID) async {
    emit(EventsCollectionLoading());

    if (!_isDataBaseAccess()) {
      return;
    }

    try {
      Tuple2<List<BaseCalendarEvent>, EventCategory> data =
          await eventsRepository!.readCategoryEvents(categoryID);

      emit(EventsCollectionReady(
          data.item1, CategoryCollectionType(data.item2)));
      return;
    } catch (e) {
      emit(EventsCollectionsError(errorMsg: e.toString()));
    }
  }

  Future<void> readEventsWithoutCategory() async {
    emit(EventsCollectionLoading());

    if (!_isDataBaseAccess()) {
      return;
    }

    try {
      List<BaseCalendarEvent> events =
          await eventsRepository!.readEventsWithoutCategory();

      emit(
          EventsCollectionReady(events, EventsWithoutCategoryCollectionType()));
    } catch (e) {
      emit(EventsCollectionsError(errorMsg: e.toString()));
    }
  }

  Future<void> readEventsFromDateRange(
      DateTime startDate, DateTime endDate) async {
    emit(EventsCollectionLoading());

    if (!_isDataBaseAccess()) {
      return;
    }

    try {
      List<BaseCalendarEvent> events =
          await eventsRepository!.readEventsFromDateRange(startDate, endDate);
      emit(EventsCollectionReady(
          events, DateRangeCollectionType(startDate, endDate)));
    } catch (e) {
      emit(EventsCollectionsError(errorMsg: e.toString()));
    }
  }

  Future<void> readDayEvents(DateTime day) async {
    emit(EventsCollectionLoading());

    if (!_isDataBaseAccess()) {
      return;
    }

    try {
      List<BaseCalendarEvent> events =
          await eventsRepository!.readEventsFromDay(day);

      emit(EventsCollectionReady(events, DayCollectionType(day)));
    } catch (e) {
      emit(EventsCollectionsError(errorMsg: e.toString()));
    }
  }

  bool _isDataBaseAccess() {
    if (eventsRepository == null) {
      emit(EventsCollectionsError(
          errorMsg: "Cannot access database - user not logged in."));
      return false;
    }

    return true;
  }

  @override
  Future<void> close() {
    _loginSubscription.cancel();
    return super.close();
  }
}
