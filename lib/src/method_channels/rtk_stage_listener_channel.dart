import 'dart:async';
import 'dart:convert';

import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';
import 'package:realtimekit_core_platform_interface/src/enums/rtk_stage_events_name.dart';
import 'package:flutter/services.dart';

import '../types/call_details.dart';

class RtkStageListenerChannel
    extends RtkListenerChannel<RtkStageEventListener> {
  final RtkJoinedMeetingParticipantApi _joinedMeetingParticipantApi;
  final RtkMeetingParticipantApi _meetingParticipantApi;
  final RtkWaitlistedParticipantApi _waitlistedParticipantApi;
  final EventChannel _channel;

  late StreamSubscription _subscription;

  RtkStageListenerChannel(
    this._channel,
    this._joinedMeetingParticipantApi,
    this._meetingParticipantApi,
    this._waitlistedParticipantApi,
  );

  final List<RtkStageEventListener> _listeners = [];

  @override
  Future<void> init(MethodChannel coreMethodChannel) async {
    _subscription = _handleStageEvents();
    await coreMethodChannel.invokeMethod('addStageEventListener');
  }

  bool _sendingCallbacksInProgress = false;
  final List<RtkStageEventListener> _addListenerAfterProcessing = [];
  final List<RtkStageEventListener> _removeListenerAfterProcessing = [];

  void _attachListenerAfterProcessing() {
    if (_addListenerAfterProcessing.isNotEmpty) {
      for (final listener in _addListenerAfterProcessing) {
        if (!_listeners.contains(listener)) {
          _listeners.add(listener);
        }
      }
      _addListenerAfterProcessing.clear();
    }
  }

  void _detachListenerAfterProcessing() {
    if (_removeListenerAfterProcessing.isNotEmpty) {
      for (final listener in _removeListenerAfterProcessing) {
        if (_listeners.contains(listener)) {
          _listeners.remove(listener);
        }
      }
      _removeListenerAfterProcessing.clear();
    }
  }

  void callAttachDetachListenerAfterProcessing() {
    _attachListenerAfterProcessing();
    _detachListenerAfterProcessing();
  }

  @override
  void attach(RtkStageEventListener listener) async {
    if (!_listeners.contains(listener)) {
      if (_sendingCallbacksInProgress) {
        _addListenerAfterProcessing.add(listener);
        return;
      } else {
        _listeners.add(listener);
      }
    }
  }

  StreamSubscription _handleStageEvents() {
    return _channel.receiveBroadcastStream().listen((event) {
      final callDetails = CallDetails.fromJson(json.encode(event));
      final recEvent = RtkStageEventsName.fromString(callDetails.name);
      _sendingCallbacksInProgress = true;

      switch (recEvent) {
        case RtkStageEventsName.onStageAccessRequestAccepted:
          for (final element in _listeners) {
            element.onStageAccessRequestAccepted();
          }
          break;
        case RtkStageEventsName.onStageAccessRequestRejected:
          for (final element in _listeners) {
            element.onStageAccessRequestRejected();
          }
          break;
        case RtkStageEventsName.onStageAccessRequestsUpdated:
          for (final element in _listeners) {
            final arg = (callDetails.args as Map)['accessRequests'];
            final accessRequests = (arg as List)
                .map((e) => RtkRemoteParticipant.fromJson(
                      json.encode(e),
                      _joinedMeetingParticipantApi,
                      _meetingParticipantApi,
                      _waitlistedParticipantApi,
                    ))
                .toList();
            element.onStageAccessRequestsUpdated(accessRequests);
          }
          break;
        case RtkStageEventsName.onNewStageAccessRequest:
          for (final element in _listeners) {
            final arg = (callDetails.args as Map)['participant'];
            final participant = RtkRemoteParticipant.fromJson(
              json.encode(arg),
              _joinedMeetingParticipantApi,
              _meetingParticipantApi,
              _waitlistedParticipantApi,
            );
            element.onNewStageAccessRequest(participant);
          }
          break;
        case RtkStageEventsName.onPeerStageStatusUpdated:
          for (final element in _listeners) {
            final arg = (callDetails.args as Map)['participant'];
            final participant = RtkRemoteParticipant.fromJson(
              json.encode(arg),
              _joinedMeetingParticipantApi,
              _meetingParticipantApi,
              _waitlistedParticipantApi,
            );
            final oldStatus =
                StageStatus.fromName(callDetails.args['oldStatus']);
            final status = StageStatus.fromName(callDetails.args['newStatus']);
            element.onPeerStageStatusUpdated(participant, oldStatus, status);
          }
          break;
        case RtkStageEventsName.onRemovedFromStage:
          for (final element in _listeners) {
            element.onRemovedFromStage();
          }
          break;
        case RtkStageEventsName.onStageStatusUpdated:
          final oldStatus = StageStatus.fromName(callDetails.args['oldStatus']);
          final newStatus = StageStatus.fromName(callDetails.args['newStatus']);

          for (final element in _listeners) {
            element.onStageStatusUpdated(oldStatus, newStatus);
          }
          break;

        case RtkStageEventsName.unknown:
          throw Exception("Unkown method called");
      }
      _sendingCallbacksInProgress = false;
      callAttachDetachListenerAfterProcessing();
    });
  }

  @override
  void detach(RtkStageEventListener listener) {
    if (_listeners.contains(listener)) {
      if (_sendingCallbacksInProgress) {
        _removeListenerAfterProcessing.add(listener);
      } else {
        _listeners.remove(listener);
      }
    }
  }

  @override
  Future<void> dispose() async {
    await _subscription.cancel();
    RtkStageController.instance.dispose();
    return;
  }
}
