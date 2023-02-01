import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:to_do_app_flutter/logic/cubit/login/login_cubit.dart';

part 'events_change_state.dart';

class EventsChangeCubit extends Cubit<EventsChangeState> {
  final LoginCubit _loginCubit;
  late final StreamSubscription _loginStreamSubscription;

  late final StreamSubscription? _baseDataSubscription;
  late final StreamSubscription? _additionalDataSubscription;

  EventsChangeCubit(this._loginCubit) : super(EventsChanged()) {
    _baseDataSubscription = null;
    _additionalDataSubscription = null;

    _loginStreamSubscription = _loginCubit.stream.listen((state) {
      _loginListener(state);
    });

    _loginListener(_loginCubit.state);
  }

  void _loginListener(LoginState state) {
    if (state is LoggedIn) {
      var docRef =
          FirebaseFirestore.instance.collection("users").doc(state.user.id);

      _baseDataSubscription =
          docRef.collection("baseEventData").snapshots().listen((event) {
        emit(EventsChanged());
      });
      _additionalDataSubscription =
          docRef.collection("additionalEventData").snapshots().listen((event) {
        emit(EventsChanged());
      });
    } else {
      _clearBaseSub();
      _clearAdditionalSub();
    }
  }

  void _clearBaseSub() {
    if (_baseDataSubscription != null) {
      _baseDataSubscription!.cancel();
      _baseDataSubscription = null;
    }
  }

  void _clearAdditionalSub() {
    if (_additionalDataSubscription != null) {
      _additionalDataSubscription!.cancel();
      _additionalDataSubscription = null;
    }
  }

  @override
  Future<void> close() {
    _loginStreamSubscription.cancel();
    _clearBaseSub();
    _clearAdditionalSub();
    return super.close();
  }
}
