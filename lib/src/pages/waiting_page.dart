import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WaitingRoom extends ConsumerWidget {
  const WaitingRoom({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor:
          AppTheme(globalDesignToken.colorToken).theme.colorScheme.surface,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(borderToken.getRadius(BorderSize.two)),
            color: AppTheme(globalDesignToken.colorToken)
                .theme
                .colorScheme
                .primaryContainer,
          ),
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
          child: RtkText(
            RtkStrings.waitingForTheHostToLetYouIn,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
