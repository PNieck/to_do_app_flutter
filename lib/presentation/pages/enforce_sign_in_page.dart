import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_app_flutter/logic/cubit/login/login_cubit.dart';

class EnforceSignInPage extends StatelessWidget {
  final Widget child;

  const EnforceSignInPage({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          if (state is LoggedIn) {
            return child;
          }

          return Column(
            children: [
              const Expanded(
                flex: 3,
                child: Icon(
                  Icons.login,
                  size: 150,
                ),
              ),
              const Text(
                "To use this app you have to be signed in.\nPlease sign in or register.",
                textAlign: TextAlign.center,
                textScaleFactor: 1.2,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    ElevatedButton(
                      onPressed: () => context.go("/sign_in"),
                      child: const Text("Sign in"),
                    ),
                    const Spacer(flex: 1),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Sign up"),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
              const Spacer()
            ],
          );
        },
      ),
    );
  }
}
