import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_app_flutter/data/models/event_category.dart';
import 'package:to_do_app_flutter/data/models/user.dart';
import 'package:to_do_app_flutter/logic/cubit/categories/categories_cubit.dart';
import 'package:to_do_app_flutter/logic/cubit/login/login_cubit.dart';
import 'package:to_do_app_flutter/presentation/elements/drawer/category_menu_pop_up.dart';
import 'package:to_do_app_flutter/presentation/elements/drawer/rename_category_pop_ip.dart';

import 'add_category_pop_up.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(child: BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: ((context, state) {
        if (state is CategoriesLoading) {
          return const WaitingDrawer();
        }
        if (state is CategoriesReady) {
          return CompleteDrawer(
            categories: state.categories,
          );
        }
        if (state is CategoriesError) {
          // #TODO
          return const WaitingDrawer();
        } else {
          context.read<CategoriesCubit>().readCategories();
          return const WaitingDrawer();
        }
      }),
    ));
  }
}

class CompleteDrawer extends StatefulWidget {
  final List<EventCategory> categories;

  const CompleteDrawer({required this.categories, super.key});

  @override
  State<CompleteDrawer> createState() => _CompleteDrawerState();
}

class _CompleteDrawerState extends State<CompleteDrawer> {
  final int additionalCnt = 6;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.categories.length + additionalCnt,
        itemBuilder: ((context, index) {
          if (index == 0) {
            return const ProfileInfo();
          }
          if (index == 1) {
            return ListTile(
              leading: const Icon(Icons.home_filled),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
                context.go("/");
              },
            );
          }
          if (index == 2) {
            return const Divider();
          }
          if (index == 3) {
            return const ListTile(
              leading: Icon(Icons.done),
              title: Text("Default"),
            );
          }
          if (index > 3 && index < widget.categories.length + 4) {
            EventCategory category = widget.categories[index - 4];

            return ListTile(
              title: Text(category.name),
              onTap: () {
                context.go("/category/${widget.categories[index - 4].id}");
                Navigator.pop(context);
              },
              onLongPress: () => showCategoryMenu(context, category),
            );
          }
          if (index == widget.categories.length + 4) {
            return const Divider();
          }
          return ListTile(
            title: const Text("Add category"),
            leading: const Icon(Icons.add),
            onTap: () => showAddCategoryPopUp(context),
          );
        }));
  }

  showAddCategoryPopUp(BuildContext context) => showDialog(
        context: context,
        builder: (newContext) {
          return BlocProvider.value(
            value: context.read<CategoriesCubit>(),
            child: const AddCategoryPopUp(),
          );
        },
      );

  showCategoryMenu(BuildContext context, EventCategory category) async {
    CategoryMenuResult? result = await showDialog(
      context: context,
      builder: (newContext) {
        return BlocProvider.value(
          value: context.read<CategoriesCubit>(),
          child: CategoryMenuPopUp(category: category),
        );
      },
    );

    if (result == null) {
      return;
    }

    if (result == CategoryMenuResult.rename) {
      showDialog(
        context: context,
        builder: (newContext) {
          return BlocProvider.value(
            value: context.read<CategoriesCubit>(),
            child: RenameCategory(category: category),
          );
        },
      );
    }
  }
}

class WaitingDrawer extends StatelessWidget {
  const WaitingDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const ProfileInfo(),
        Center(
          child: Container(
            constraints: BoxConstraints.tight(const Size(50, 50)),
            child: const CircularProgressIndicator(
              semanticsLabel: "Loading Categories",
            ),
          ),
        )
      ],
    );
  }
}

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 150),
      color: const Color.fromARGB(255, 223, 223, 223),
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: ((context, state) {
          if (state is LoggedIn) {
            return LoggedInHeader(user: state.user);
          }
          return const NotLoggedInHeader();
        }),
      ),
    );
  }
}

class LoggedInHeader extends StatelessWidget {
  final AppUser user;

  const LoggedInHeader({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AvatarImage(
          imageUrl: user.photo,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.name == null || user.name!.isEmpty
                  ? "Logged as ${user.email}"
                  : "Logged as ${user.name!}",
              maxLines: 4,
              overflow: TextOverflow.clip,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go("/profile");
              },
              child: const Text("Profile"),
            )
          ],
        )
      ],
    );
  }
}

class NotLoggedInHeader extends StatelessWidget {
  const NotLoggedInHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const AvatarImage(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("You are not logged in"),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go("/sign_in");
              },
              child: const Text("Sign in"),
            )
          ],
        )
      ],
    );
    ;
  }
}

class AvatarImage extends StatelessWidget {
  final String? imageUrl;

  const AvatarImage({this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: Colors.white,
        radius: 50,
        child: Builder(builder: ((context) {
          if (imageUrl == null) {
            return const CircleAvatar(
              backgroundColor: Color(0xffE6E6E6),
              radius: 45,
              child: Icon(
                Icons.person,
                size: 80,
                color: Color(0xffCCCCCC),
              ),
            );
          }
          return CircleAvatar(
            backgroundImage: NetworkImage(imageUrl!),
            radius: 45,
          );
        })));
  }
}
