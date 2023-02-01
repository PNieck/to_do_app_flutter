import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RegisterScreen(
      actions: [
        AuthStateChangeAction<UserCreated>((context, state) {
          context.go("/verify_mail");
        })
      ],
    );
  }
}
