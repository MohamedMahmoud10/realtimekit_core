import 'package:realtimekit_ui/realtimekit_ui.dart';

class RtkTabParticipant {
  dynamic participant;
  final RtkTabParticipantType type;
  bool isSelected;

  RtkTabParticipant(
    this.participant, {
    required this.type,
    this.isSelected = false,
  });

  void toggleSelected() {
    isSelected = !isSelected;
  }

  @override
  bool operator ==(covariant RtkTabParticipant other) {
    if (identical(this, other)) return true;
    return other.participant.runtimeType == participant.runtimeType &&
        participant == other.participant &&
        other.type == type &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode =>
      participant.hashCode ^ type.hashCode ^ isSelected.hashCode;

  @override
  String toString() =>
      'RtkTabParticipant(participant: $participant, type: $type, isSelected: $isSelected)';

  RtkTabParticipant copyWith({
    dynamic participant,
    RtkTabParticipantType? type,
    bool? isSelected,
  }) {
    return RtkTabParticipant(
      participant ?? this.participant,
      type: type ?? this.type,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

extension RtkTabParticipantExtension on RtkTabParticipant {
  String get name => type == RtkTabParticipantType.screenshare
      ? screenshare.name
      : plugin.name;

  RtkMeetingParticipant get screenshare =>
      type == RtkTabParticipantType.screenshare
          ? participant
          : throw Exception('Participant is not a screenshare');
  RtkPlugin get plugin => type == RtkTabParticipantType.plugin
      ? participant
      : throw Exception('Participant is not a plugin');
}

enum RtkTabParticipantType {
  plugin,
  screenshare,
}
