import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';
import 'package:realtimekit_ui/src/widgets/atoms/vh_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/riverpod_di.dart';

class LiveViewerCountWidget extends ConsumerWidget {
  const LiveViewerCountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewerCount = ref.watch(
      lvsStateNotifier.select(
        (state) => rtkMeeting.livestream.data.viewerCount,
      ),
    );
    return rtkMeeting.meta.meetingType == RtkMeetingType.livestream
        ? Row(children: [
            const Icon(DyteIcons.viewers),
            hspace1,
            RtkText(
              viewerCount.toString(),
            )
          ])
        : const SizedBox.shrink();
  }
}
