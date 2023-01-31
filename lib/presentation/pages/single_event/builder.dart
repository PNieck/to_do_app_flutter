import 'dart:async';
import 'dart:io';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_flutter/logic/cubit/events/single_event_cubit.dart';
import 'package:to_do_app_flutter/presentation/pages/error_page.dart';
import 'package:to_do_app_flutter/presentation/pages/loading_page.dart';
import 'package:to_do_app_flutter/presentation/pages/single_event/display_event.dart';

import '../../../logic/cubit/events/events_change_cubit.dart';

class SingleEventPageBuilder extends StatefulWidget {
  final String eventID;
  const SingleEventPageBuilder({required this.eventID, super.key});

  @override
  State<SingleEventPageBuilder> createState() => _SingleEventPageBuilderState();
}

class _SingleEventPageBuilderState extends State<SingleEventPageBuilder> {
  late final StreamSubscription collectionChangedSub;

  @override
  void initState() {
    super.initState();

    context.read<SingleEventCubit>().readSingleEvent(widget.eventID);
    collectionChangedSub =
        context.read<EventsChangeCubit>().stream.listen((state) {
      if (state is EventsChanged) {
        context.read<SingleEventCubit>().readSingleEvent(widget.eventID);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SingleEventCubit, SingleEventState>(
      builder: (context, state) {
        if (state is SingleEventLoading) {
          sleep(const Duration(milliseconds: 10));
          return const LoadingPage();
        }

        if (state is SingleEventReady) {
          return DisplaySingleEvent(event: state.event);
        }

        if (state is SingleEventError) {
          return ErrorPage(
            errorMessage: state.toString(),
          );
        }

        return const ErrorPage(errorMessage: "Unknown error");
      },
    );
  }

  @override
  void dispose() {
    collectionChangedSub.cancel();
    super.dispose();
  }
}
