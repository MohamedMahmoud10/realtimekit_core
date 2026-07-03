import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_list_tile.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';

class GoLiveButtonWidget extends ConsumerWidget {
  const GoLiveButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lvsState = ref.watch(
        lvsStateNotifier.select((value) => rtkMeeting.livestream.data.state));

    return RtkListTile(
      leading: (lvsState == LivestreamState.started ||
              lvsState == LivestreamState.ended ||
              lvsState == LivestreamState.none)
          ? Icon(lvsState == LivestreamState.ended ||
                  lvsState == LivestreamState.none
              ? DyteIcons.start_livestream
              : DyteIcons.stop_livestream)
          : const CircularProgressIndicator(),
      iconColor: lvsState == LivestreamState.started
          ? AppTheme(globalDesignToken.colorToken).theme.colorScheme.error
          : null,
      title: RtkText(
        lvsState == LivestreamState.started
            ? "Stop Live"
            : lvsState == LivestreamState.ended ||
                    lvsState == LivestreamState.none
                ? "Go Live"
                : lvsState == LivestreamState.starting
                    ? "Starting Livestream"
                    : "Stopping Livestream",
      ),
      onTap: lvsState == LivestreamState.started
          ? rtkMeeting.livestream.stop
          : lvsState == LivestreamState.ended ||
                  lvsState == LivestreamState.none
              ? rtkMeeting.livestream.start
              : null,
    );
  }
}
