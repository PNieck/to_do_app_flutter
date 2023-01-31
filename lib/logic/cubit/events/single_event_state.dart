part of 'single_event_cubit.dart';

@immutable
abstract class SingleEventState {}

class SingleEventInitial extends SingleEventState {}

class SingleEventLoading extends SingleEventState {}

class SingleEventReady extends SingleEventState {
  final CalendarEvent event;

  SingleEventReady(this.event);
}

class SingleEventCreatedSuccessfully extends SingleEventState {}

class SingleEventDeletedSuccessfully extends SingleEventState {}

class SingleEventError extends SingleEventState {
  final String? errorMsg;

  SingleEventError({this.errorMsg});

  @override
  String toString() {
    if (errorMsg == null) {
      return "An error ocurred while operating on single event";
    }

    return errorMsg!;
  }
}
