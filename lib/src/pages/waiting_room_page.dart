import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:flutter/material.dart';

class WaitingRoomPage extends StatelessWidget {
  const WaitingRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return Scaffold(
      appBar: AppBar(
        actions: const [RtkReleaseResourcesButton()],
        automaticallyImplyLeading: false,
      ),
      body: SizedBox(
        child: Center(
          child: Container(
            width: context.width * 0.75,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: theme.colorScheme.secondaryContainer,
            ),
            child: const Text(
              'You are in the waiting room, the host will let you in soon.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
