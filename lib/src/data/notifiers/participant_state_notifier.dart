import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/di/di.dart';

import '../states/participant_event_states.dart';

class ParticipantNotifier extends Notifier<ParticipantEventStates>
    implements RtkParticipantsEventListener {
  @override
  ParticipantEventStates build() {
    return ParticipantEventStatesInitial();
  }

  @override
  void onAudioUpdate(
    RtkMeetingParticipant participant,
    bool isEnabled,
  ) {
    state = OnAudioUpdate(audioEnabled: isEnabled, participant: participant);
  }

  @override
  void onActiveSpeakerChanged(RtkMeetingParticipant? participant) {
    state = OnActiveSpeakerChanged(participant);
  }

  @override
  void onParticipantJoin(RtkMeetingParticipant participant) {
    state = OnParticipantJoin(participant);
  }

  @override
  void onParticipantLeave(RtkMeetingParticipant participant) {
    state = OnParticipantLeave(participant);
  }

  @override
  void onParticipantPinned(RtkMeetingParticipant participant) {
    state = OnParticipantPinned(participant);
  }

  @override
  void onActiveParticipantsChanged(List<RtkMeetingParticipant> active) {
    state = OnActiveParticipantsChanged(activeParticipants: active);
  }

  @override
  void onParticipantUnpinned(RtkMeetingParticipant participant) {
    state = OnParticipantUnpinned(participant);
  }

  @override
  void onVideoUpdate(
    RtkMeetingParticipant participant,
    bool isEnabled,
  ) {
    state = OnVideoUpdate(videoEnabled: isEnabled, participant: participant);
  }

  @override
  void onUpdate(RtkParticipants participants) {
    state = OnUpdate(participants);
  }

  @override
  void onNewBroadcastMessage(String type, Map<String, dynamic> payload) {
    // TODO: implement onNewBroadcastMessage
  }

  @override
  void onScreenShareUpdate(RtkRemoteParticipant participant, bool isEnabled) {
    state = OnScreenSharesUpdated();
  }
}

class UnreadWaitlistedCountNotifier extends Notifier<int>
    implements RtkWaitlistEventListener {
  @override
  int build() {
    rtkMeeting.participantsStream.listen((participant) {
      state = rtkMeeting.participants.waitlisted.length;
    });
    return rtkMeeting.participants.waitlisted.length;
  }

  @override
  void onWaitListParticipantAccepted(RtkMeetingParticipant participant) {}

  @override
  void onWaitListParticipantClosed(RtkMeetingParticipant participant) {}

  @override
  void onWaitListParticipantJoined(RtkMeetingParticipant participant) {}

  @override
  void onWaitListParticipantRejected(RtkMeetingParticipant participant) {}
}
