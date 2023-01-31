import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:go_router/go_router.dart';

class AppSignInPage extends StatelessWidget {
  const AppSignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          if (!state.user!.emailVerified) {
            context.go("/verify_mail");
          } else {
            context.go("/");
          }
        }),
      ],
    );
  }
}
