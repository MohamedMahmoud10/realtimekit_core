import 'dart:async';
import 'dart:convert';

import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';
import 'package:realtimekit_core_platform_interface/src/enums/rtk_self_listener.dart';
import 'package:realtimekit_core_platform_interface/src/types/call_details.dart';
import 'package:realtimekit_core_platform_interface/src/utils/int_to_bool_convertor.dart';
import 'package:flutter/services.dart';

class RtkSelfListenerChannel extends RtkListenerChannel<RtkSelfEventListener> {
  final EventChannel _channel;
  final RtkLocalUserApi _localUserApi;
  final RtkJoinedMeetingParticipantApi joinedMeetingParticipantApi;
  final RtkMeetingParticipantApi meetingParticipantApi;
  late StreamSubscription _subscription;
  RtkSelfListenerChannel(
    this._channel,
    this._localUserApi,
    this.joinedMeetingParticipantApi,
    this.meetingParticipantApi,
  );

  final List<RtkSelfEventListener> _listeners = [];

  @override
  Future<void> init(MethodChannel coreMethodChannel) async {
    _subscription = _handleLocalUserEvents();
    await coreMethodChannel.invokeMethod('addSelfParticipantEventListener');
  }

  bool _sendingCallbacksInProgress = false;
  final List<RtkSelfEventListener> _addListenerAfterProcessing = [];
  final List<RtkSelfEventListener> _removeListenerAfterProcessing = [];

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
  void attach(RtkSelfEventListener listener) {
    if (!_listeners.contains(listener)) {
      if (_sendingCallbacksInProgress) {
        _addListenerAfterProcessing.add(listener);
        return;
      } else {
        _listeners.add(listener);
      }
    }
  }

  StreamSubscription _handleLocalUserEvents() {
    return _channel.receiveBroadcastStream().listen((call) async {
      final callDetails = CallDetails.fromJson(json.encode(call));
      final RtkSelfListenerMethodNames listenerMethod =
          RtkSelfListenerMethodNames.fromName(callDetails.name);
      _sendingCallbacksInProgress = true;

      switch (listenerMethod) {
        case RtkSelfListenerMethodNames
            .onMeetingRoomJoinedWithoutCameraPermission:
          for (final listener in _listeners) {
            listener.onMeetingRoomJoinedWithoutCameraPermission();
          }
          break;
        case RtkSelfListenerMethodNames.onMeetingRoomJoinedWithoutMicPermission:
          for (final listener in _listeners) {
            listener.onMeetingRoomJoinedWithoutMicPermission();
          }
          break;
        case RtkSelfListenerMethodNames.onAudioUpdate:
          final isEnabled = decodeBool(callDetails.args["isEnabled"]);
          for (final listener in _listeners) {
            listener.onAudioUpdate(isEnabled);
          }
          break;
        case RtkSelfListenerMethodNames.onVideoUpdate:
          final isEnabled = decodeBool(callDetails.args["isEnabled"]);
          for (final listener in _listeners) {
            listener.onVideoUpdate(isEnabled);
          }
          break;
        case RtkSelfListenerMethodNames.onAudioDevicesUpdated:
          for (final listener in _listeners) {
            final arg = callDetails.args["devices"] as List<dynamic>;
            final audioDevices =
                arg.map((e) => AudioDevice.fromJson(json.encode(e))).toList();
            listener.onAudioDevicesUpdated(audioDevices);
          }
          break;
        case RtkSelfListenerMethodNames.onVideoDeviceChanged:
          final arg = callDetails.args["videoDevice"] as Map<String, dynamic>;
          final videoDevice = VideoDevice.fromJson(json.encode(arg));
          for (final listener in _listeners) {
            listener.onVideoDeviceChanged(videoDevice);
          }
          break;
        case RtkSelfListenerMethodNames.onWaitListStatusUpdate:
          final waitListStatus =
              WaitlistStatus.fromName(callDetails.args["waitlistStatus"]);
          for (final listener in _listeners) {
            listener.onWaitListStatusUpdate(waitListStatus);
          }
          break;
        case RtkSelfListenerMethodNames.onUpdate:
          final participant = RtkSelfParticipant.fromJson(
            json.encode(callDetails.args["participant"]),
            _localUserApi,
            joinedMeetingParticipantApi,
            meetingParticipantApi,
          );
          for (final listener in _listeners) {
            listener.onUpdate(participant);
          }
          break;
        case RtkSelfListenerMethodNames.onRemovedFromMeeting:
          for (final listener in _listeners) {
            listener.onRemovedFromMeeting();
          }
          break;
        case RtkSelfListenerMethodNames.onPermissionsUpdated:
          final permissions = SelfPermissions.fromJson(
            json.encode(callDetails.args['permissions']),
          );
          for (final listener in _listeners) {
            listener.onPermissionsUpdated(permissions);
          }
          break;
        case RtkSelfListenerMethodNames.onScreenShareUpdate:
          final isEnabled = decodeBool(callDetails.args['isEnabled']);
          for (final listener in _listeners) {
            listener.onScreenShareUpdate(isEnabled);
          }
          break;
        case RtkSelfListenerMethodNames.onPinned:
          for (final listener in _listeners) {
            listener.onPinned();
          }
          break;
        case RtkSelfListenerMethodNames.onUnpinned:
          for (final listener in _listeners) {
            listener.onUnpinned();
          }
          break;
        case RtkSelfListenerMethodNames.onAudioDeviceChanged:
          final arg = callDetails.args["device"] as Map<String, dynamic>;
          final audioDevice = AudioDevice.fromJson(json.encode(arg));
          for (final listener in _listeners) {
            listener.onAudioDeviceChanged(audioDevice);
          }
          break;
        case RtkSelfListenerMethodNames.unknown:
          throw UnimplementedError("Method not implemented yet");
        // break;
        default:
          throw UnimplementedError("Method not implemented yet");
      }
      _sendingCallbacksInProgress = false;
      callAttachDetachListenerAfterProcessing();
    });
  }

  @override
  void detach(RtkSelfEventListener listener) {
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
