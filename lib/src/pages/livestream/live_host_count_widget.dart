import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';

import '../../widgets/atoms/vh_space.dart';

class LiveHostCountWidget extends ConsumerWidget {
  const LiveHostCountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(children: [
      const Icon(DyteIcons.participants),
      hspace1,
      StreamBuilder<RtkParticipants>(
        initialData: rtkMeeting.participants,
        stream: rtkMeeting.participantsStream,
        builder: (context, snapshot) =>
            RtkText(snapshot.data!.active.length.toString()),
      ),
    ]);
  }
}
