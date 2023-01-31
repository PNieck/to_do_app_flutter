part of 'events_change_cubit.dart';

@immutable
abstract class EventsChangeState {}

class EventsChangeInitialState extends EventsChangeState {}

class EventsChanged extends EventsChangeState {}

class EventsChangeError extends EventsChangeState {
  final String? errorMsg;

  EventsChangeError({this.errorMsg});

  @override
  String toString() {
    if (errorMsg == null) {
      return "Events collection error";
    }

    return errorMsg!;
  }
}
