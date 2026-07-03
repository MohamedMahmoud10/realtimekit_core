import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/data/states/livestream_states.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:realtimekit_ui/src/tokens/color/status_color.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';
import 'package:realtimekit_ui/src/widgets/atoms/vh_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LiveIndicatorWidget extends ConsumerWidget {
  const LiveIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(lvsStateNotifier.select(
        (value) => value is OnLivestreamStarted || value is OnLivestreamEnded));
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return rtkMeeting.livestream.data.state == LivestreamState.started
        ? Row(
            children: [
              const Icon(
                DyteIcons.start_livestream,
                color: Colors.red,
              ),
              hspace1,
              RtkText(
                "LIVE",
                rtkTextStyle: theme.textTheme.bodyMedium!
                    .copyWith(color: StatusColor.error),
              )
            ],
          )
        : const SizedBox.shrink();
  }
}
