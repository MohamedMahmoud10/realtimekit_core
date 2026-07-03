import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';

class ParticipantsNotifier extends StreamNotifier<ParticipantsState>
    implements RtkStageEventListener {
  StreamController<ParticipantsState>? _controller;
  StreamSubscription? _participantsSubscription;

  @override
  Stream<ParticipantsState> build() {
    _controller = StreamController<ParticipantsState>.broadcast();

    return Stream.multi((controller) {
      // Emit initial state immediately
      controller.add(_buildParticipantsState());

      // Listen to participant changes and emit updates
      _participantsSubscription = rtkMeeting.participantsStream.listen((_) {
        controller.add(_buildParticipantsState());
      });

      controller.onCancel = () {
        _participantsSubscription?.cancel();
        _participantsSubscription = null;
      };
    });
  }

  void dispose() {
    _participantsSubscription?.cancel();
    _participantsSubscription = null;
    _controller?.close();
    _controller = null;
  }

  ParticipantsState _buildParticipantsState() {
    final participants = rtkMeeting.participants;
    final meetingType = rtkMeeting.meta.meetingType;
    final stageRequests = rtkMeeting.stage.accessRequests;

    List<RtkRemoteParticipant> activeParticipants = participants.active;
    List<RtkRemoteParticipant> inCallParticipants = [];
    List<RtkMeetingParticipant> viewerParticipants = [];
    List<RtkMeetingParticipant> presenterParticipants = [];

    if (meetingType == RtkMeetingType.groupCall) {
      inCallParticipants = participants.joined;
    } else if (meetingType == RtkMeetingType.webinar) {
      viewerParticipants = participants.joined
          .where((participant) {
            return participant.stageStatus != StageStatus.onStage;
          })
          .cast<RtkMeetingParticipant>()
          .toList();

      presenterParticipants = participants.joined
          .where((participant) {
            return participant.stageStatus == StageStatus.onStage;
          })
          .cast<RtkMeetingParticipant>()
          .toList();

      if (rtkMeeting.localUser.stageStatus == StageStatus.onStage) {
        presenterParticipants.add(rtkMeeting.localUser);
      } else {
        viewerParticipants.add(rtkMeeting.localUser);
      }
    }

    return ParticipantsState(
      active: activeParticipants,
      inCall: inCallParticipants,
      viewers: viewerParticipants,
      presenters: presenterParticipants,
      waitlisted: participants.waitlisted,
      stageRequests: stageRequests,
      localUser: rtkMeeting.localUser,
      meetingType: meetingType,
    );
  }

  @override
  void onNewStageAccessRequest(RtkRemoteParticipant participant) {
    // TODO: implement onNewStageAccessRequest
  }

  @override
  void onPeerStageStatusUpdated(RtkRemoteParticipant participant,
      StageStatus oldStatus, StageStatus newStatus) {
    // TODO: implement onPeerStageStatusUpdated
  }

  @override
  void onRemovedFromStage() {
    _controller?.add(_buildParticipantsState());
  }

  @override
  void onStageAccessRequestAccepted() {
    _controller?.add(_buildParticipantsState());
  }

  @override
  void onStageAccessRequestRejected() {
    // TODO: implement onStageAccessRequestRejected
  }

  @override
  void onStageAccessRequestsUpdated(List<RtkRemoteParticipant> accessRequests) {
    // TODO: implement onStageAccessRequestsUpdated
  }

  @override
  void onStageStatusUpdated(StageStatus oldStatus, StageStatus newStatus) {
    _controller?.add(_buildParticipantsState());
  }
}

/// Immutable state class containing all participant categories
class ParticipantsState {
  final List<RtkRemoteParticipant> active;
  final List<RtkRemoteParticipant> inCall;
  final List<RtkMeetingParticipant> viewers;
  final List<RtkMeetingParticipant> presenters;
  final List<RtkMeetingParticipant> waitlisted;
  final List<RtkRemoteParticipant> stageRequests;
  final RtkMeetingParticipant localUser;
  final RtkMeetingType meetingType;
  final int totalGridParticipants;

  // TODO: Update totalGridParticipants based on the preset
  const ParticipantsState({
    required this.active,
    required this.inCall,
    required this.viewers,
    required this.presenters,
    required this.waitlisted,
    required this.stageRequests,
    required this.localUser,
    required this.meetingType,
  }) : totalGridParticipants = 6;

  factory ParticipantsState.initial() {
    return ParticipantsState(
      active: [],
      inCall: [],
      viewers: [],
      presenters: [],
      waitlisted: [],
      stageRequests: [],
      localUser: rtkMeeting.localUser,
      meetingType: rtkMeeting.meta.meetingType,
    );
  }

  List<RtkRemoteParticipant> get mainParticipants {
    final isZerothPage = rtkMeeting.participants.grid.currentPageNumber == 0;
    if (meetingType != RtkMeetingType.groupCall || !isZerothPage) {
      return active;
    }

    // Reserve 1 slot for local user
    final maxRemoteParticipants = totalGridParticipants - 1;
    final activeIds = active.map((e) => e.id).toSet();
    final backfillCount = maxRemoteParticipants - active.length;
    final backfill = inCall
        .where((e) => !activeIds.contains(e.id))
        .take(backfillCount > 0 ? backfillCount : 0)
        .toList();

    return (active + backfill).take(maxRemoteParticipants).toList();
  }

  int get totalParticipantCount {
    return mainParticipants.length + 1;
  }

  bool get hasWaitlistedParticipants => waitlisted.isNotEmpty;

  bool get hasStageRequests => stageRequests.isNotEmpty;

  bool get isWebinar => meetingType == RtkMeetingType.webinar;

  bool get isGroupCall => meetingType == RtkMeetingType.groupCall;
}
