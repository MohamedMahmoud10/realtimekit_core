import 'package:realtimekit_ui/src/data/models/rtk_selected_tab_participant.dart';
import 'package:realtimekit_ui/src/data/models/rtk_tab_participant.dart';
import 'package:realtimekit_ui/src/di/di.dart';

import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RtkTabNotifier extends Notifier<RtkSelectedTabParticipant> {
  void watchScreenshareAndPluginChanges() {
    final screenshares = ref.watch(screenshareProvider);
    final pluginState = ref.watch(pluginProvider);
    final selfScreensharePresent = ref.watch(selfScreenshareProvider);

    if (selfScreensharePresent) {
      screenshares.add(rtkMeeting.localUser);
    }

    final screenShareTabParticipants = screenshares.map((e) {
      return RtkTabParticipant(e,
          type: RtkTabParticipantType.screenshare, isSelected: false);
    }).toList();

    final pluginTabParticipants = pluginState.map((e) {
      return RtkTabParticipant(e,
          type: RtkTabParticipantType.plugin, isSelected: false);
    }).toList();

    final rtkTabParticipant = [
      ...screenShareTabParticipants,
      ...pluginTabParticipants
    ];

    final rtkTabParticipantWithFirstSelected = rtkTabParticipant
        .map((e) => e.copyWith(isSelected: rtkTabParticipant.first == e))
        .toList();

    state = RtkSelectedTabParticipant(
        participant: rtkTabParticipantWithFirstSelected);
  }

  void selectParticipant(RtkTabParticipant participant) {
    RtkSelectedTabParticipant currentParticipant =
        RtkSelectedTabParticipant(participant: state.participant);
    currentParticipant = currentParticipant.select(participant);
    state = currentParticipant;
  }

  List<RtkTabParticipant> get participants => state.participant;

  RtkTabParticipant get selected => state.selected;

  @override
  RtkSelectedTabParticipant build() {
    state = RtkSelectedTabParticipant.empty();
    watchScreenshareAndPluginChanges();
    return state;
  }
}
