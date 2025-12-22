import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';

abstract class RtkRecording {
  RecordingState get recordingState =>
      RtkRecordingController.instance.recordingState;
  void start(OnResult onResult);
  void stop(OnResult onResult);
}

enum RecordingState {
  idle("idle"),
  recording("recording"),
  starting("starting"),
  stopping("stopping");

  final String state;
  const RecordingState(this.state);

  static RecordingState fromName(String state) {
    switch (state) {
      case "starting":
        return RecordingState.starting;
      case "recording":
        return RecordingState.recording;
      case "stopping":
        return RecordingState.stopping;
      case "idle":
        return RecordingState.idle;
      default:
        return RecordingState.idle;
    }
  }
}
