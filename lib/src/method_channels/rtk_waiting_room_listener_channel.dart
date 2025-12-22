import 'dart:async';
import 'dart:convert';

import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';
import 'package:realtimekit_core_platform_interface/src/enums/rtk_waiting_room_events.dart';
import 'package:flutter/services.dart';

import '../types/call_details.dart';

class RtkWaitingRoomListenerChannel
    extends RtkListenerChannel<RtkWaitlistEventListener> {
  final EventChannel _channel;
  final RtkWaitlistedParticipantApi waitlistedParticipantApi;
  final RtkMeetingParticipantApi meetingParticipantApi;
  final RtkJoinedMeetingParticipantApi _joinedMeetingParticipantApi;

  late StreamSubscription _subscription;

  RtkWaitingRoomListenerChannel(
    this._joinedMeetingParticipantApi,
    this._channel,
    this.waitlistedParticipantApi,
    this.meetingParticipantApi,
  );

  final List<RtkWaitlistEventListener> _listeners = [];

  @override
  Future<void> init(MethodChannel coreMethodChannel) async {
    _subscription = _handleWaitingRoomEvents();
    await coreMethodChannel.invokeMethod('addWaitingRoomEventListener');
  }

  bool _sendingCallbacksInProgress = false;
  final List<RtkWaitlistEventListener> _addListenerAfterProcessing = [];
  final List<RtkWaitlistEventListener> _removeListenerAfterProcessing = [];

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
  void attach(RtkWaitlistEventListener listener) {
    if (!_listeners.contains(listener)) {
      if (_sendingCallbacksInProgress) {
        _addListenerAfterProcessing.add(listener);
        return;
      } else {
        _listeners.add(listener);
      }
    }
  }

  StreamSubscription _handleWaitingRoomEvents() {
    return _channel.receiveBroadcastStream().listen((event) {
      final callDetails = CallDetails.fromJson(json.encode(event));
      final name = RtkWaitlistedParticipantEvents.fromName(callDetails.name);
      _sendingCallbacksInProgress = true;

      switch (name) {
        case RtkWaitlistedParticipantEvents.onWaitListParticipantAccepted:
          final participant = (callDetails.args as Map)['participant'];
          final rtkParticipant = RtkRemoteParticipant.fromJson(
            json.encode(participant),
            _joinedMeetingParticipantApi,
            meetingParticipantApi,
            waitlistedParticipantApi,
          );
          for (final element in _listeners) {
            element.onWaitListParticipantAccepted(rtkParticipant);
          }
          break;
        case RtkWaitlistedParticipantEvents.onWaitListParticipantClosed:
          final participant = (callDetails.args as Map)['participant'];
          final rtkParticipant = RtkRemoteParticipant.fromJson(
            json.encode(participant),
            _joinedMeetingParticipantApi,
            meetingParticipantApi,
            waitlistedParticipantApi,
          );
          for (final element in _listeners) {
            element.onWaitListParticipantClosed(rtkParticipant);
          }
          break;
        case RtkWaitlistedParticipantEvents.onWaitListParticipantJoined:
          final participant = (callDetails.args as Map)['participant'];
          final rtkParticipant = RtkRemoteParticipant.fromJson(
            json.encode(participant),
            _joinedMeetingParticipantApi,
            meetingParticipantApi,
            waitlistedParticipantApi,
          );
          for (final element in _listeners) {
            element.onWaitListParticipantJoined(rtkParticipant);
          }
          break;
        case RtkWaitlistedParticipantEvents.onWaitListParticipantRejected:
          final participant = (callDetails.args as Map)['participant'];
          final rtkParticipant = RtkRemoteParticipant.fromJson(
            json.encode(participant),
            _joinedMeetingParticipantApi,
            meetingParticipantApi,
            waitlistedParticipantApi,
          );
          for (final element in _listeners) {
            element.onWaitListParticipantRejected(rtkParticipant);
          }
          break;
        case RtkWaitlistedParticipantEvents.unknown:
          throw Exception("Unkown method called");
      }
      _sendingCallbacksInProgress = false;
      callAttachDetachListenerAfterProcessing();
    });
  }

  @override
  void detach(RtkWaitlistEventListener listener) {
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
    return;
  }
}
