import 'dart:async';

import 'package:to_do_app_flutter/logic/cubit/login/login_cubit.dart';

import '../../../data/repositories/events_repository.dart';

class EventsRepositoryHandler {
  final LoginCubit _loginCubit;
  late final StreamSubscription _loginSubscription;

  EventsRepository? eventsRepository;

  EventsRepositoryHandler(this._loginCubit) {
    _loginSubscription = _loginCubit.stream.listen((state) {
      if (state is LoggedIn) {
        eventsRepository = EventsRepository(state.user);
        return;
      }

      eventsRepository = null;
    });
  }

  void dispose() {
    _loginSubscription.cancel();
  }
}
