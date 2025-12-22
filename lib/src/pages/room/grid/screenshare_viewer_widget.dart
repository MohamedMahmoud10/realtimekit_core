import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScreenshareViewerWidget extends ConsumerStatefulWidget {
  const ScreenshareViewerWidget(this.participant, {super.key});

  final RtkMeetingParticipant participant;

  @override
  ConsumerState createState() => _ScreensharePageState();
}

class _ScreensharePageState extends ConsumerState<ScreenshareViewerWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractiveViewer(
        child: ScreenshareView(widget.participant),
      ),
    );
  }
}
