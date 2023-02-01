import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_app_flutter/logic/cubit/categories/categories_cubit.dart';
import 'package:to_do_app_flutter/logic/cubit/events/events_change_cubit.dart';
import 'package:to_do_app_flutter/logic/cubit/login/login_cubit.dart';
import 'package:to_do_app_flutter/presentation/elements/drawer/drawer.dart';
import 'package:to_do_app_flutter/presentation/pages/category_page/category_page.dart';
import 'package:to_do_app_flutter/presentation/pages/edit_event.dart/edit_event.dart';
import 'package:to_do_app_flutter/presentation/pages/email_verify_page.dart';
import 'package:to_do_app_flutter/presentation/pages/new_event/new_event_page.dart';
import 'package:to_do_app_flutter/presentation/pages/enforce_sign_in_page.dart';
import 'package:to_do_app_flutter/presentation/pages/profile_page.dart';
import 'package:to_do_app_flutter/presentation/pages/register_page.dart';
import 'package:to_do_app_flutter/presentation/pages/sign_in_page.dart';
import 'package:to_do_app_flutter/presentation/pages/single_event/single_event_page.dart';
import 'pages/todays_events/todays_events_page.dart';

class AppRouter {
  final GlobalKey<NavigatorState> _rootNavigatorKey;
  final GlobalKey<NavigatorState> _shellNavigatorKey;

  final LoginCubit loginCubit = LoginCubit();
  late final EventsChangeCubit _eventsChangeCubit;
  late final CategoriesCubit _categoriesCubit;

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: "/",
    routes: [
      ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: loginCubit),
                  BlocProvider.value(value: _categoriesCubit),
                  BlocProvider.value(value: _eventsChangeCubit),
                ],
                child: Scaffold(
                  appBar: AppBar(title: const Text("Calendar App")),
                  drawer: const AppDrawer(),
                  body: child,
                ),
              ),
          routes: [
            GoRoute(
                path: "/",
                builder: ((context, state) =>
                    const EnforceSignInPage(child: TodaysEventsPage())),
                routes: [
                  GoRoute(
                      path: "event/:eventID",
                      builder: (context, state) =>
                          SingleEventPage(eventID: state.params["eventID"]!),
                      routes: [
                        GoRoute(
                          path: "edit",
                          builder: (context, state) =>
                              EditEventPage(eventID: state.params["eventID"]!),
                        )
                      ]),
                  GoRoute(
                    path: "new_event",
                    builder: (context, state) => const NewEventPage(),
                  ),
                  GoRoute(
                    path: "verify_mail",
                    builder: (context, state) => const EmailVerificationPage(),
                  ),
                  GoRoute(
                    path: "profile",
                    builder: (context, state) => const ProfilePage(),
                  ),
                  GoRoute(
                      path: "category/:categoryID",
                      builder: (context, state) =>
                          CategoryPage(categoryID: state.params["categoryID"]!),
                      routes: [
                        GoRoute(
                          path: "event/:eventID",
                          builder: (context, state) => SingleEventPage(
                              eventID: state.params["eventID"]!),
                        )
                      ]),
                ]),
            GoRoute(
              path: "/sign_in",
              builder: (context, state) => const AppSignInPage(),
            ),
            GoRoute(
              path: "/sign_up",
              builder: (context, state) => const RegisterPage(),
            )
          ])
    ],
  );

  AppRouter()
      : _rootNavigatorKey = GlobalKey<NavigatorState>(),
        _shellNavigatorKey = GlobalKey<NavigatorState>() {
    _categoriesCubit = CategoriesCubit(loginCubit: loginCubit);
    _eventsChangeCubit = EventsChangeCubit(loginCubit);
  }
}
