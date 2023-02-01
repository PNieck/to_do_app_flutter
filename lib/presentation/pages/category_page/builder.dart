import 'dart:async';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_flutter/logic/cubit/events/events_collections_cubit.dart';
import 'package:to_do_app_flutter/presentation/pages/category_page/category_events_list.dart';
import 'package:to_do_app_flutter/presentation/pages/error_page.dart';
import 'package:to_do_app_flutter/presentation/pages/loading_page.dart';

import '../../../logic/cubit/events/events_change_cubit.dart';

class CategoryPageBuilder extends StatefulWidget {
  final String categoryID;

  const CategoryPageBuilder({required this.categoryID, super.key});

  @override
  State<CategoryPageBuilder> createState() => _CategoryPageBuilderState();
}

class _CategoryPageBuilderState extends State<CategoryPageBuilder> {
  late final StreamSubscription collectionChangedSub;

  @override
  void initState() {
    super.initState();

    context
        .read<EventsCollectionsCubit>()
        .readEventsFromCategory(widget.categoryID);
    collectionChangedSub =
        context.read<EventsChangeCubit>().stream.listen((state) {
      if (state is EventsChanged) {
        context
            .read<EventsCollectionsCubit>()
            .readEventsFromCategory(widget.categoryID);
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
          if (collectionType is CategoryCollectionType) {
            if (collectionType.category.id == widget.categoryID) {
              return CategoryEventsList(
                  events: state.events, category: collectionType.category);
            }
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
  void didUpdateWidget(covariant CategoryPageBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    EventsCollectionsState state = context.read<EventsCollectionsCubit>().state;
    if (state is EventsCollectionReady) {
      EventsCollectionType collectionType = state.collectionType;
      if (collectionType is! CategoryCollectionType ||
          collectionType.category.id != widget.categoryID) {
        context
            .read<EventsCollectionsCubit>()
            .readEventsFromCategory(widget.categoryID);
      }
    }
  }

  @override
  void dispose() {
    collectionChangedSub.cancel();
    super.dispose();
  }
}
