import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/src/data/states/local_user_states.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';
import 'package:realtimekit_ui/src/widgets/atoms/vh_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecorderWidget extends ConsumerWidget {
  const RecorderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    final recordingState = ref.watch(recordingNotifier);
    ref.watch(
        localUserSettingsProvider.select((value) => value is OnVideoUpdate));

    final recWid = Padding(
      padding: ref.read(localUserSettingsProvider.notifier).isVideoEnabled
          ? EdgeInsets.zero
          : EdgeInsets.only(right: hspace4.width!),
      child: Row(
        children: [
          if (recordingState == RecordingState.recording) ...[
            Icon(
              DyteIcons.recording,
              color: theme.colorScheme.error,
              size: context.adjust(10),
            ),
            SizedBox(
              width: context.adjust(5),
            ),
            RtkText(
              RtkStrings.rec,
              rtkTextStyle: theme.textTheme.bodyMedium!
                  .copyWith(color: theme.colorScheme.error),
            ),
          ],
        ],
      ),
    );

    return recWid;
  }
}
