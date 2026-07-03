import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/data/notifiers/video_notifier.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/utils/generate_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoIcon extends ConsumerStatefulWidget {
  final RtkMeetingParticipant participant;
  final double? iconSize;

  const VideoIcon({
    super.key,
    required this.participant,
    this.iconSize,
  });

  @override
  ConsumerState<VideoIcon> createState() => _VideoIconState();
}

class _VideoIconState extends ConsumerState<VideoIcon> {
  late final VideoNotifier videoNotifier;

  @override
  void initState() {
    videoNotifier = VideoNotifier(widget.participant);
    rtkMeeting.addParticipantsEventListener(videoNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;

    return ValueListenableBuilder(
      valueListenable: videoNotifier,
      builder: (context, bool videoEnabled, child) => Icon(
        videoEnabled ? DyteIcons.video_on : DyteIcons.video_off,
        key: generateVideoKeyForParticipant(
          widget.participant,
          pageName: 'VideoIcon',
        ),
        size: widget.iconSize ?? 24,
        color: videoEnabled
            ? theme.colorScheme.onSecondary
            : theme.colorScheme.error,
      ),
    );
  }

  @override
  void dispose() {
    rtkMeeting.removeParticipantsEventListener(videoNotifier);
    super.dispose();
  }
}
