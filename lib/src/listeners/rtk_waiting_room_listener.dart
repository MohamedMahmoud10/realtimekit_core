import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';

abstract class RtkWaitlistEventListener extends RtkListener {
  void onWaitListParticipantAccepted(RtkRemoteParticipant participant) {}
  void onWaitListParticipantClosed(RtkRemoteParticipant participant) {}
  void onWaitListParticipantJoined(RtkRemoteParticipant participant) {}
  void onWaitListParticipantRejected(RtkRemoteParticipant participant) {}
}
