import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/di/di.dart';

class RecordingNotifer extends Notifier<RecordingState>
    implements RtkRecordingEventListener {
  @override
  RecordingState build() {
    return rtkMeeting.recording.recordingState;
  }

  @override
  void onRecordingStateChanged(
      RecordingState oldState, RecordingState newState) {
    state = newState;
  }
}
