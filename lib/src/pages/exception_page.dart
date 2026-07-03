import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:realtimekit_ui/src/widgets/atoms/vh_space.dart';
import 'package:flutter/material.dart';
import 'package:realtimekit_ui/src/widgets/core/core.dart';

class ExceptionPage extends StatelessWidget {
  final MeetingError exception;
  const ExceptionPage(this.exception, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Error: ${exception.message}"),
          vspace2,
          RtkButtons.solid(
            label: RtkStrings.back,
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
    ));
  }
}
