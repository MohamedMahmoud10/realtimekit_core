import 'dart:async';

import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';

abstract class RtkParticipantsEventListener extends RtkListener {
  void onParticipantJoin(RtkRemoteParticipant participant) {}
  void onParticipantLeave(RtkRemoteParticipant participant) {}
  void onScreenShareUpdate(RtkRemoteParticipant participant, bool isEnabled) {}
  void onAudioUpdate(RtkRemoteParticipant participant, bool isEnabled) {}
  void onVideoUpdate(RtkRemoteParticipant participant, bool isEnabled) {}
  void onActiveSpeakerChanged(RtkRemoteParticipant? participant) {}
  void onParticipantPinned(RtkRemoteParticipant participant) {}
  void onParticipantUnpinned(RtkRemoteParticipant participant) {}
  void onUpdate(RtkParticipants participants) {}
  void onActiveParticipantsChanged(List<RtkRemoteParticipant> active) {}
  void onNewBroadcastMessage(String type, Map<String, dynamic> payload) {}
}

class _RtkParticipantsApiImpl implements RtkParticipantsApi {
  @override
  void setPage(int pageNumber) {
    // stub
  }

  @override
  void disableAllVideo({OnResult? onResult}) {
    // stub
  }

  @override
  void disableAllAudio({OnResult? onResult}) {
    // stub
  }

  @override
  void kickAll({OnResult? onResult}) {
    // stub
  }

  @override
  void acceptWaitlistedParticipant(
      RtkMeetingParticipant waitlistingParticipant) {
    // stub
  }

  @override
  void rejectWaitlistedParticipant(
      RtkMeetingParticipant waitlistingParticipant) {
    // stub
  }

  @override
  void broadcastMessage(String type, Map<String, dynamic> payload) {
    // stub
  }

  @override
  void acceptAllWaitingRoomRequests() {
    // stub
  }
}

final participantsApi = _RtkParticipantsApiImpl();

class RtkParticipantController extends RtkParticipantsEventListener {
  RtkParticipantController._();

  static final RtkParticipantController instance = RtkParticipantController._();
  final StreamController<RtkParticipants> _participantController =
      StreamController.broadcast()
        ..add(
          RtkParticipants(
            participantsApi,
            waitlisted: [],
            joined: [],
            active: [],
            screenshares: [],
            pinned: null,
            grid: GridPagesInfo(
              pageCount: 1,
              currentPageNumber: 1,
              isNextPagePossible: false,
              isPreviousPagePossible: false,
            ),
          ),
        );

  final StreamController<List<RtkRemoteParticipant>>
      _activeParticipantController = StreamController.broadcast()..add([]);

  Stream<RtkParticipants> get participantStream =>
      _participantController.stream;

  Stream<List<RtkRemoteParticipant>> get activeStream =>
      _activeParticipantController.stream;

  void closeActiveStream() => _activeParticipantController.close();

  void closeParticipantStream() => _participantController.close();

  RtkParticipants get currentParticipants => _rtkRoomParticipants;

  RtkParticipants _rtkRoomParticipants = RtkParticipants(
    participantsApi,
    waitlisted: [],
    joined: [],
    active: [],
    screenshares: [],
    pinned: null,
    grid: GridPagesInfo(
      pageCount: 1,
      currentPageNumber: 1,
      isNextPagePossible: false,
      isPreviousPagePossible: false,
    ),
  );

  @override
  void onActiveParticipantsChanged(List<RtkRemoteParticipant> active) {
    super.onActiveParticipantsChanged(active);
    _activeParticipantController.add(active);
  }

  @override
  void onUpdate(RtkParticipants participants) {
    _rtkRoomParticipants = participants;
    _activeParticipantController.add(_rtkRoomParticipants.active);
    _participantController.add(_rtkRoomParticipants);
  }

  @override
  void onParticipantPinned(RtkRemoteParticipant participant) {
    _rtkRoomParticipants.pinned = participant;
  }

  @override
  void onParticipantUnpinned(RtkRemoteParticipant participant) {
    _rtkRoomParticipants.pinned = null;
  }
}
