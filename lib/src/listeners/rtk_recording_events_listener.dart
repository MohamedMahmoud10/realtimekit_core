import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';

abstract class RtkRecordingEventListener extends RtkListener {
  void onRecordingStateChanged(
      RecordingState oldState, RecordingState newState);
}

class RtkRecordingController extends RtkRecordingEventListener {
  RtkRecordingController._();

  static final RtkRecordingController instance = RtkRecordingController._();

  RecordingState _recordingState = RecordingState.idle;

  RecordingState get recordingState => _recordingState;

  @override
  void onRecordingStateChanged(
      RecordingState oldState, RecordingState newState) {
    _recordingState = newState;
  }

  void dispose() {
    _recordingState = RecordingState.idle;
  }
}
