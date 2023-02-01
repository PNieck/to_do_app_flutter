import 'dart:async';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_flutter/logic/cubit/events/events_collections_cubit.dart';
import 'package:to_do_app_flutter/presentation/pages/category_events_list.dart';
import 'package:to_do_app_flutter/presentation/pages/category_page/category_page.dart';
import 'package:to_do_app_flutter/presentation/pages/error_page.dart';
import 'package:to_do_app_flutter/presentation/pages/loading_page.dart';

import '../../../logic/cubit/events/events_change_cubit.dart';

class DefaultCategoryPageBuilder extends StatefulWidget {
  const DefaultCategoryPageBuilder({super.key});

  @override
  State<DefaultCategoryPageBuilder> createState() =>
      _DefaultCategoryPageBuilderState();
}

class _DefaultCategoryPageBuilderState
    extends State<DefaultCategoryPageBuilder> {
  late final StreamSubscription collectionChangedSub;

  @override
  void initState() {
    super.initState();

    context.read<EventsCollectionsCubit>().readEventsWithoutCategory();
    collectionChangedSub =
        context.read<EventsChangeCubit>().stream.listen((state) {
      if (state is EventsChanged) {
        context.read<EventsCollectionsCubit>().readEventsWithoutCategory();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsCollectionsCubit, EventsCollectionsState>(
      builder: (context, state) {
        if (state is EventsCollectionLoading ||
            state is EventsCollectionsInitial) {
          return const LoadingPage();
        }

        if (state is EventsCollectionReady) {
          EventsCollectionType collectionType = state.collectionType;
          if (collectionType is EventsWithoutCategoryCollectionType) {
            return CategoryEventsList(events: state.events);
          }

          return const ErrorPage(errorMessage: "Invalid collection loaded");
        }

        if (state is EventsCollectionsError) {
          return ErrorPage(errorMessage: state.toString());
        }

        return const ErrorPage(errorMessage: "Unknown error curred");
      },
    );
  }

  @override
  void didUpdateWidget(covariant DefaultCategoryPageBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    EventsCollectionsState state = context.read<EventsCollectionsCubit>().state;
    if (state is EventsCollectionReady) {
      EventsCollectionType collectionType = state.collectionType;
      if (collectionType is! EventsWithoutCategoryCollectionType) {}
      context.read<EventsCollectionsCubit>().readEventsWithoutCategory();
    }
  }

  @override
  void dispose() {
    collectionChangedSub.cancel();
    super.dispose();
  }
}
