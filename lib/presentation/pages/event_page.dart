/*import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_flutter/data/models/calendar_event.dart';
import 'package:to_do_app_flutter/presentation/elements/drawer/drawer.dart';
import 'package:to_do_app_flutter/presentation/pages/error_page.dart';
import 'package:to_do_app_flutter/presentation/pages/loading_page.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key, required this.eventId});

  final String eventId;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    context.read<EventsCubit>().readEvent(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (context) {
      return BlocBuilder<EventsCubit, EventsState>(
        builder: (context, state) {
          if (state is EventReady && state.event.id == widget.eventId) {
            return ShowEventPage(event: state.event);
          }

          if (state is EventsLoading) {
            return const LoadingPage();
          }

          if (state is EventsError) {
            return const ErrorPage();
          }

          //context.read<EventsCubit>().readEvent(eventId);
          return const LoadingPage();
        },
      );
    }));
  }
}

class ShowEventPage extends StatelessWidget {
  final CalendarEvent event;

  const ShowEventPage({required this.event, super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}*/
