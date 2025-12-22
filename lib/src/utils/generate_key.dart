import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:flutter/foundation.dart';

ValueKey<String> generateKeyForParticipant(
  RtkMeetingParticipant participant, {
  String pageName = 'RtkGridView',
}) {
  return ValueKey('RtkParticipant:${participant.id}:$pageName');
}

ValueKey<String> generateAudioKeyForParticipant(
  RtkMeetingParticipant participant, {
  String pageName = 'RtkGridView',
}) {
  return ValueKey('RtkParticipantAudio:${participant.id}:$pageName');
}

ValueKey<String> generateVideoKeyForParticipant(
  RtkMeetingParticipant participant, {
  String pageName = 'RtkGridView',
}) {
  return ValueKey('RtkParticipantVideo:${participant.id}:$pageName');
}
