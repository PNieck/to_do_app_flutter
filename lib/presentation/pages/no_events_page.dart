import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

class NoEventsPage extends StatelessWidget {
  const NoEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go("/new_event");
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: const [
          Expanded(
            flex: 3,
            child: Icon(
              Icons.event,
              size: 150,
            ),
          ),
          Center(
            child: Text(
              "There is no events there.\nClick + to add one.",
              textAlign: TextAlign.center,
              textScaleFactor: 1.2,
            ),
          ),
          Spacer()
        ],
      ),
    );
  }
}
