import 'dart:async';

import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/di.dart';

class RtkMeetingNotifier extends AutoDisposeNotifier<Duration?>
    implements RtkDataEventListener {
  late DateTime dateUtc;
  late Duration meetingDuration;
  bool isTimestampPresent = false;
  Timer? _timer;

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final newDuration = DateTime.now().difference(dateUtc);
      if (state == null || newDuration.inSeconds != state!.inSeconds) {
        state = newDuration;
      }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Duration? build() {
    ref.onDispose(() {
      _cancelTimer();
    });

    if (rtkMeeting.meta.meetingStartedTimeStamp == "") {
      return null;
    }
    isTimestampPresent = true;
    dateUtc = DateTime.parse(
      rtkMeeting.meta.meetingStartedTimeStamp,
    ).toLocal();
    meetingDuration = DateTime.now().difference(dateUtc);
    _startTimer();
    return meetingDuration;
  }

  @override
  void onLivestreamUpdate(RtkLivestreamData livestreamData) {}

  @override
  void onMetaUpdate(
    String roomName,
    String meetingTitle,
    String meetingStartedTimestamp,
    RtkMeetingType meetingType,
    RtkDesignTokens designTokens,
  ) {
    if (!isTimestampPresent && meetingStartedTimestamp != "") {
      isTimestampPresent = true;
      dateUtc = DateTime.parse(
        meetingStartedTimestamp,
      ).toLocal();
      meetingDuration = DateTime.now().difference(dateUtc);
      _startTimer();
    }
  }

  @override
  void onPluginUpdate(List<RtkPlugin> plugin) {}

  @override
  void onScreenShareUpdate(List<RtkRemoteParticipant> screenShares) {}

  @override
  void onSelfPermissionsUpdate(SelfPermissions permissions) {}
}
