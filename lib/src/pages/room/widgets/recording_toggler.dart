import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_icon_button.dart';

import 'package:flutter/material.dart';

class RecordingToggler extends StatefulWidget {
  final RecordingState recordingState;
  const RecordingToggler(this.recordingState, {super.key});

  @override
  State<RecordingToggler> createState() => _RecordingTogglerState();
}

class _RecordingTogglerState extends State<RecordingToggler> {
  @override
  Widget build(BuildContext context) {
    return RtkIconButton(
        icon: Icon(
          widget.recordingState == RecordingState.recording
              ? DyteIcons.stop_recording
              : DyteIcons.recording,
        ),
        onPressed: () {
          switch (widget.recordingState) {
            case RecordingState.idle:
              rtkMeeting.recording.start((err) {});
              break;
            case RecordingState.recording:
              rtkMeeting.recording.stop((err) {});
              break;
            default:
              null;
          }
        });
  }
}
