import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;
  const ErrorPage({this.errorMessage = "", super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(
            flex: 3,
            child: Icon(
              Icons.error_outline,
              size: 150,
            ),
          ),
          Center(
            child: Text(
              "Sorry, an error has occurred. Try again later.\n$errorMessage",
              textAlign: TextAlign.center,
              textScaleFactor: 1.2,
            ),
          ),
          const Spacer()
        ],
      ),
    );
  }
}
