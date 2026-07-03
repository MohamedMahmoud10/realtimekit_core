import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/di/di.dart';

class GridNotifier extends Notifier<GridPagesInfo>
    implements RtkParticipantsEventListener {
  void previousPage() {
    final grid = rtkMeeting.participants.grid;
    if (grid.isPreviousPagePossible) {
      rtkMeeting.participants.setPage(grid.currentPageNumber - 1);
    }
  }

  void nextPage() {
    final grid = rtkMeeting.participants.grid;
    if (grid.isNextPagePossible) {
      rtkMeeting.participants.setPage(grid.currentPageNumber + 1);
    }
  }

  @override
  GridPagesInfo build() {
    final grid = rtkMeeting.participants.grid;
    return grid;
  }

  @override
  void onUpdate(RtkParticipants participants) {
    state = participants.grid;
  }

  @override
  void onActiveParticipantsChanged(List<RtkRemoteParticipant> active) {}

  @override
  void onActiveSpeakerChanged(RtkRemoteParticipant? participant) {}

  @override
  void onAudioUpdate(RtkRemoteParticipant participant, bool isEnabled) {}

  @override
  void onParticipantJoin(RtkRemoteParticipant participant) {}

  @override
  void onParticipantLeave(RtkRemoteParticipant participant) {}

  @override
  void onParticipantPinned(RtkRemoteParticipant participant) {}

  @override
  void onParticipantUnpinned(RtkRemoteParticipant participant) {}

  @override
  void onVideoUpdate(RtkRemoteParticipant participant, bool isEnabled) {}

  @override
  void onNewBroadcastMessage(String type, Map<String, dynamic> payload) {
    // TODO: implement onNewBroadcastMessage
  }

  @override
  void onScreenShareUpdate(RtkRemoteParticipant participant, bool isEnabled) {
    // TODO: implement onScreenShareUpdate
  }
}
