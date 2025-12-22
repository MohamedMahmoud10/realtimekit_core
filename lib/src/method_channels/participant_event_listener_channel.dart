import 'dart:async';
import 'dart:convert';

import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';
import 'package:realtimekit_core_platform_interface/src/enums/rtk_participant_event_listeners_method.dart';
import 'package:realtimekit_core_platform_interface/src/types/call_details.dart';
import 'package:realtimekit_core_platform_interface/src/utils/int_to_bool_convertor.dart';
import 'package:flutter/services.dart';

class RtkParticipantEventsListenerChannel
    extends RtkListenerChannel<RtkParticipantsEventListener> {
  final EventChannel channel;
  final RtkJoinedMeetingParticipantApi joinedMeetingParticipantApi;
  final RtkMeetingParticipantApi meetingParticipantApi;
  final RtkLocalUserApi localUserApi;
  final RtkWaitlistedParticipantApi waitlistedParticipantApi;
  final RtkParticipantsApi participantsApi;

  late StreamSubscription _subscription;

  RtkParticipantEventsListenerChannel(
    this.channel,
    this.joinedMeetingParticipantApi,
    this.meetingParticipantApi,
    this.waitlistedParticipantApi,
    this.localUserApi,
    this.participantsApi,
  );

  final List<RtkParticipantsEventListener> _listeners = [];

  @override
  Future<void> init(MethodChannel coreMethodChannel) async {
    _subscription = _handleParticipantEvents();
    await coreMethodChannel.invokeMethod('addParticipantsEventListener');
  }

  bool _sendingCallbacksInProgress = false;
  final List<RtkParticipantsEventListener> _addListenerAfterProcessing = [];
  final List<RtkParticipantsEventListener> _removeListenerAfterProcessing = [];

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
  void attach(RtkParticipantsEventListener listener) {
    if (!_listeners.contains(listener)) {
      if (_sendingCallbacksInProgress) {
        _addListenerAfterProcessing.add(listener);
        return;
      } else {
        _listeners.add(listener);
      }
    }
  }

  StreamSubscription _handleParticipantEvents() {
    return channel.receiveBroadcastStream().listen((call) async {
      final callDetails = CallDetails.fromJson(json.encode(call));
      final method =
          RtkParticipantEventListenerMethod.fromName(callDetails.name);
      _sendingCallbacksInProgress = true;
      switch (method) {
        case RtkParticipantEventListenerMethod.onAudioUpdate:
          final isEnabled = decodeBool(callDetails.args["isEnabled"]);
          final participant = RtkRemoteParticipant.fromJson(
            json.encode(callDetails.args["participant"]),
            joinedMeetingParticipantApi,
            meetingParticipantApi,
            waitlistedParticipantApi,
          );
          for (final participantEventsListener in _listeners) {
            participantEventsListener.onAudioUpdate(participant, isEnabled);
          }
          break;
        case RtkParticipantEventListenerMethod.onActiveSpeakerChanged:
          if (callDetails.args["participant"] != null) {
            final participant = RtkRemoteParticipant.fromJson(
              json.encode(callDetails.args["participant"]),
              joinedMeetingParticipantApi,
              meetingParticipantApi,
              waitlistedParticipantApi,
            );
            for (final participantEventsListener in _listeners) {
              participantEventsListener.onActiveSpeakerChanged(participant);
            }
          } else {
            for (final participantEventsListener in _listeners) {
              participantEventsListener.onActiveSpeakerChanged(null);
            }
          }
          break;
        case RtkParticipantEventListenerMethod.onParticipantJoin:
          final participant = RtkRemoteParticipant.fromJson(
            json.encode(callDetails.args["participant"]),
            joinedMeetingParticipantApi,
            meetingParticipantApi,
            waitlistedParticipantApi,
          );
          for (final participantEventsListener in _listeners) {
            participantEventsListener.onParticipantJoin(participant);
          }
          break;
        case RtkParticipantEventListenerMethod.onParticipantLeave:
          final participant = RtkRemoteParticipant.fromJson(
            json.encode(callDetails.args["participant"]),
            joinedMeetingParticipantApi,
            meetingParticipantApi,
            waitlistedParticipantApi,
          );
          for (final participantEventsListener in _listeners) {
            participantEventsListener.onParticipantLeave(participant);
          }
          break;
        case RtkParticipantEventListenerMethod.onParticipantPinned:
          final participant = RtkRemoteParticipant.fromJson(
            json.encode(callDetails.args["participant"]),
            joinedMeetingParticipantApi,
            meetingParticipantApi,
            waitlistedParticipantApi,
          );
          for (final participantEventsListener in _listeners) {
            participantEventsListener.onParticipantPinned(participant);
          }
          break;
        case RtkParticipantEventListenerMethod.onParticipantUnpinned:
          final participant = RtkRemoteParticipant.fromJson(
            json.encode(callDetails.args["participant"]),
            joinedMeetingParticipantApi,
            meetingParticipantApi,
            waitlistedParticipantApi,
          );
          for (final participantEventsListener in _listeners) {
            participantEventsListener.onParticipantUnpinned(participant);
          }
          break;
        case RtkParticipantEventListenerMethod.onScreenShareUpdate:
          final participant = RtkRemoteParticipant.fromJson(
            json.encode(callDetails.args["participant"]),
            joinedMeetingParticipantApi,
            meetingParticipantApi,
            waitlistedParticipantApi,
          );
          final isEnabled = decodeBool(callDetails.args["isEnabled"]);
          for (final participantEventsListener in _listeners) {
            participantEventsListener.onScreenShareUpdate(
                participant, isEnabled);
          }
          break;
        case RtkParticipantEventListenerMethod.onVideoUpdate:
          final participant = RtkRemoteParticipant.fromJson(
            json.encode(callDetails.args["participant"]),
            joinedMeetingParticipantApi,
            meetingParticipantApi,
            waitlistedParticipantApi,
          );
          final isEnabled = decodeBool(callDetails.args["isEnabled"]);
          for (final participantEventsListener in _listeners) {
            participantEventsListener.onVideoUpdate(participant, isEnabled);
          }
          break;
        case RtkParticipantEventListenerMethod.onUpdate:
          final participantMap = callDetails.args["participants"];
          if (participantMap != null) {
            final participants = RtkParticipants.fromJson(
              json.encode(participantMap),
              joinedMeetingParticipantApi,
              localUserApi,
              waitlistedParticipantApi,
              meetingParticipantApi,
              participantsApi,
            );
            for (final participantEventsListener in _listeners) {
              participantEventsListener.onUpdate(participants);
            }
          }
          break;
        case RtkParticipantEventListenerMethod.onActiveParticipantsChanged:
          final resParticipants = callDetails.args["active"] as List<dynamic>;
          final activeParticipants = resParticipants
              .map((e) => RtkRemoteParticipant.fromJson(
                    json.encode(e),
                    joinedMeetingParticipantApi,
                    meetingParticipantApi,
                    waitlistedParticipantApi,
                  ))
              .toList();
          for (final participantEventsListener in _listeners) {
            participantEventsListener
                .onActiveParticipantsChanged(activeParticipants);
          }
          break;

        case RtkParticipantEventListenerMethod.unknown:
          throw Exception("Unknown platform method executed");
        case RtkParticipantEventListenerMethod.onNewBroadcastMessage:
          final String type = callDetails.args['type'];
          final Map<String, dynamic> payload = callDetails.args['payload'];
          for (final listener in _listeners) {
            listener.onNewBroadcastMessage(type, payload);
          }
          break;
      }
      _sendingCallbacksInProgress = false;
      callAttachDetachListenerAfterProcessing();
    });
  }

  @override
  void detach(RtkParticipantsEventListener listener) {
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
