import 'package:realtimekit_ui/src/data/models/rtk_tab_participant.dart';

import 'package:flutter/foundation.dart';

class RtkSelectedTabParticipant {
  final List<RtkTabParticipant> participant;

  bool get isEmpty => participant.isEmpty;

  RtkTabParticipant get selected =>
      participant.firstWhere((element) => element.isSelected);

  RtkSelectedTabParticipant({
    required this.participant,
  });

  RtkSelectedTabParticipant.empty() : participant = [];

  void addTabbedParticipant(RtkTabParticipant participant) {
    this.participant.add(participant);
  }

  RtkSelectedTabParticipant refreshWithNewParticipants(
      List<RtkTabParticipant> participants) {
    participant.clear();
    participant.addAll(participants);
    return this;
  }

  void removeParticipant(RtkTabParticipant participant) {
    this.participant.remove(participant);
  }

  RtkSelectedTabParticipant select(RtkTabParticipant participant) {
    for (final p in this.participant) {
      p.isSelected = p == participant;
    }
    return this;
  }

  RtkSelectedTabParticipant copyWith({
    List<RtkTabParticipant>? participant,
  }) {
    return RtkSelectedTabParticipant(
      participant: participant ?? this.participant,
    );
  }

  @override
  String toString() => 'RtkTabSelectedParticipant(participant: $participant)';

  @override
  bool operator ==(covariant RtkSelectedTabParticipant other) {
    if (identical(this, other)) return true;

    return listEquals(other.participant, participant);
  }

  @override
  int get hashCode => participant.hashCode;
}
