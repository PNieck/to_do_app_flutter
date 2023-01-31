import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:go_router/go_router.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EmailVerificationScreen(
      actions: [
        EmailVerifiedAction(() {
          context.go("/");
        }),
        AuthCancelledAction((context) {
          FirebaseUIAuth.signOut(context: context);
          context.go("/");
        }),
      ],
    );
  }
}
