import 'package:realtimekit_core/realtimekit_core.dart';

abstract class ParticipantEventStates {}

class ParticipantEventStatesInitial extends ParticipantEventStates {}

class OnAudioUpdate extends ParticipantEventStates {
  final bool audioEnabled;
  final RtkMeetingParticipant participant;

  OnAudioUpdate({required this.audioEnabled, required this.participant});
}

class OnActiveSpeakerChanged extends ParticipantEventStates {
  final RtkMeetingParticipant? participant;

  OnActiveSpeakerChanged(this.participant);
}

class OnNoActiveSpeaker extends ParticipantEventStates {}

class OnParticipantJoin extends ParticipantEventStates {
  final RtkMeetingParticipant participant;

  OnParticipantJoin(this.participant);
}

class OnParticipantLeave extends ParticipantEventStates {
  final RtkMeetingParticipant participant;

  OnParticipantLeave(this.participant);
}

class OnParticipantPinned extends ParticipantEventStates {
  final RtkMeetingParticipant participant;

  OnParticipantPinned(this.participant);
}

class OnParticipantUnpinned extends ParticipantEventStates {
  final RtkMeetingParticipant participant;
  OnParticipantUnpinned(this.participant);
}

class OnScreenSharesUpdated extends ParticipantEventStates {}

class OnUpdate extends ParticipantEventStates {
  final RtkParticipants participants;

  OnUpdate(this.participants);
}

class OnVideoUpdate extends ParticipantEventStates {
  final bool videoEnabled;
  final RtkMeetingParticipant participant;

  OnVideoUpdate({required this.videoEnabled, required this.participant});
}

class OnActiveParticipantsChanged extends ParticipantEventStates {
  final List<RtkMeetingParticipant> activeParticipants;

  OnActiveParticipantsChanged({required this.activeParticipants});
}
