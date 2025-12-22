import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RtkMeetingTimerWidget extends ConsumerWidget {
  const RtkMeetingTimerWidget({super.key});

  static final _theme = AppTheme(globalDesignToken.colorToken).theme;

  static String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meetingDuration = ref.watch(meetingTimeProvider);

    return RepaintBoundary(
      child: meetingDuration != null
          ? RtkText(
              _formatDuration(meetingDuration),
              rtkTextStyle: _theme.textTheme.bodyLarge,
            )
          : const RtkText(
              '',
              rtkTextStyle: null, // Will use default style
            ),
    );
  }
}
