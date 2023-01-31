import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_flutter/Helpers/date_time.dart';
import 'package:to_do_app_flutter/logic/cubit/events/events_change_cubit.dart';

import '../../../logic/cubit/events/events_collections_cubit.dart';
import '../error_page.dart';
import '../loading_page.dart';
import '../no_events_page.dart';
import 'ready_page.dart';

class TodaysPageBuilder extends StatefulWidget {
  const TodaysPageBuilder({super.key});

  @override
  State<TodaysPageBuilder> createState() => _TodaysPageBuilderState();
}

class _TodaysPageBuilderState extends State<TodaysPageBuilder> {
  late final StreamSubscription collectionChangedSub;
  final DateTime today;

  _TodaysPageBuilderState() : today = DateTime.now();

  @override
  void initState() {
    super.initState();

    context.read<EventsCollectionsCubit>().readDayEvents(today);
    collectionChangedSub =
        context.read<EventsChangeCubit>().stream.listen((state) {
      if (state is EventsChanged) {
        context.read<EventsCollectionsCubit>().readDayEvents(DateTime.now());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EventsCollectionsCubit, EventsCollectionsState>(
        builder: (context, state) => builder(context, state),
      ),
    );
  }

  Widget builder(BuildContext context, EventsCollectionsState state) {
    //final DateTime nowDaTeTime = DateTime.now();

    if (state is EventsCollectionReady) {
      EventsCollectionType collectionType = state.collectionType;
      if (collectionType is DayCollectionType &&
          collectionType.day.isSameDay(today)) {
        if (state.events.isEmpty) {
          return const NoEventsPage();
        }

        return TodayReadyPage(state.events);
      }
    }

    if (state is EventsCollectionLoading) {
      return const LoadingPage();
    }

    if (state is EventsCollectionsError) {
      return ErrorPage(errorMessage: state.toString());
    }

    return const ErrorPage();
  }

  @override
  void dispose() {
    collectionChangedSub.cancel();
    super.dispose();
  }
}
