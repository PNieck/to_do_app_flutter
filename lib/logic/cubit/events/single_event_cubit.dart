import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:to_do_app_flutter/data/models/calendar_event.dart';
import 'package:to_do_app_flutter/data/repositories/events_repository.dart';
import 'package:to_do_app_flutter/logic/cubit/login/login_cubit.dart';

part 'single_event_state.dart';

class SingleEventCubit extends Cubit<SingleEventState> {
  final LoginCubit _loginCubit;
  late final StreamSubscription _loginSubscription;

  EventsRepository? eventsRepository;

  SingleEventCubit(this._loginCubit) : super(SingleEventInitial()) {
    _loginSubscription = _loginCubit.stream.listen((state) {
      if (state is LoggedIn) {
        eventsRepository = EventsRepository(state.user);
        return;
      }

      eventsRepository = null;
      emit(SingleEventError(
          errorMsg: "Cannot fetch data - user not logged in."));
    });

    LoginState loginState = _loginCubit.state;
    if (loginState is LoggedIn) {
      eventsRepository = EventsRepository(loginState.user);
    }
  }

  Future<void> readSingleEvent(String eventID) async {
    emit(SingleEventLoading());

    if (!_isDataBaseAccess()) {
      return;
    }

    try {
      CalendarEvent event = await eventsRepository!.readEvent(eventID);

      emit(SingleEventReady(event));
    } catch (e) {
      emit(SingleEventError(errorMsg: e.toString()));
    }
  }

  Future<void> createEvent(CalendarEvent event) async {
    emit(SingleEventLoading());

    if (!_isDataBaseAccess()) {
      return;
    }

    try {
      await eventsRepository!.createEvent(event);

      emit(SingleEventCreatedSuccessfully());
    } catch (e) {
      emit(SingleEventError(errorMsg: e.toString()));
    }
  }

  Future<void> updateEvent(
      CalendarEvent updatedEvent, CalendarEvent oldEvent) async {
    emit(SingleEventLoading());

    if (!_isDataBaseAccess()) {
      return;
    }

    try {
      await eventsRepository!.updateEvent(updatedEvent, oldEvent);

      emit(SingleEventUpdatedSuccessfully());
    } catch (e) {
      emit(SingleEventError(errorMsg: e.toString()));
    }
  }

  Future<void> deleteEvent(String eventID) async {
    emit(SingleEventLoading());

    if (!_isDataBaseAccess()) {
      return;
    }

    try {
      await eventsRepository!.deleteEvent(eventID);

      emit(SingleEventDeletedSuccessfully());
    } catch (e) {
      emit(SingleEventError(errorMsg: e.toString()));
    }
  }

  bool _isDataBaseAccess() {
    if (eventsRepository == null) {
      emit(SingleEventError(
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
