import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';
import 'package:realtimekit_core_platform_interface/src/enums/rtk_room_event_names.dart';
import 'package:realtimekit_core_platform_interface/src/types/call_details.dart';
import 'package:realtimekit_core_platform_interface/src/utils/ext_set_active_tab.dart';

class RtkMeetingRoomEventListenerChannel
    extends RtkListenerChannel<RtkMeetingRoomEventListener> {
  final EventChannel _channel;
  late StreamSubscription _subscription;

  RtkMeetingRoomEventListenerChannel(this._channel);

  final List<RtkMeetingRoomEventListener> _listeners = [];

  @override
  Future<void> init(MethodChannel coreMethodChannel) async {
    _subscription = _handleRoomEvents();
    await coreMethodChannel.invokeMethod('addMeetingRoomEventListener');
  }

  bool _sendingCallbacksInProgress = false;
  final List<RtkMeetingRoomEventListener> _addListenerAfterProcessing = [];
  final List<RtkMeetingRoomEventListener> _removeListenerAfterProcessing = [];

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
  void attach(RtkMeetingRoomEventListener listener) async {
    if (!_listeners.contains(listener)) {
      if (_sendingCallbacksInProgress) {
        _addListenerAfterProcessing.add(listener);
        return;
      } else {
        _listeners.add(listener);
      }
    }
  }

  StreamSubscription _handleRoomEvents() {
    return _channel.receiveBroadcastStream().listen((event) {
      final callDetails = CallDetails.fromJson(json.encode(event));
      final roomEvent = RtkRoomEventName.fromString(callDetails.name);
      _sendingCallbacksInProgress = true;

      switch (roomEvent) {
        case RtkRoomEventName.onMeetingInitStarted:
          for (final element in _listeners) {
            element.onMeetingInitStarted();
          }
          break;

        case RtkRoomEventName.onMeetingInitFailed:
          for (final element in _listeners) {
            final errorCode = callDetails.args["exception"]["code"];
            final error = MeetingErrorUtils.fromErrorCode(
                errorCode: int.parse(errorCode));
            element.onMeetingInitFailed(error);
          }
          break;
        case RtkRoomEventName.onMeetingInitCompleted:
          for (final element in _listeners) {
            element.onMeetingInitCompleted();
          }
          break;

        case RtkRoomEventName.onMeetingRoomJoinCompleted:
          for (final element in _listeners) {
            element.onMeetingRoomJoinCompleted();
          }
          break;
        case RtkRoomEventName.onMeetingRoomJoinFailed:
          for (final element in _listeners) {
            final errorCode = callDetails.args["exception"]["code"];
            final error = MeetingErrorUtils.fromErrorCode(
              errorCode: int.parse(errorCode),
            );
            element.onMeetingRoomJoinFailed(error);
          }
          break;
        case RtkRoomEventName.onMeetingRoomJoinStarted:
          for (final element in _listeners) {
            element.onMeetingRoomJoinStarted();
          }
          break;
        case RtkRoomEventName.onMeetingRoomLeaveCompleted:
          for (final element in _listeners) {
            element.onMeetingRoomLeaveCompleted();
          }
          break;
        case RtkRoomEventName.onMeetingRoomLeaveStarted:
          for (final element in _listeners) {
            element.onMeetingRoomLeaveStarted();
          }
          break;
        case RtkRoomEventName.onActiveTabUpdate:
          final ActiveTab? activeTab = callDetails.args["activeTab"] == null
              ? null
              : ActiveTab.fromMap(callDetails.args["activeTab"]);
          RtkClientPlatform.instance.meta.setActiveTab = activeTab;
          for (final element in _listeners) {
            element.onActiveTabUpdate(activeTab);
          }
          break;

        case RtkRoomEventName.onMeetingEnded:
          for (final element in _listeners) {
            element.onMeetingEnded();
          }
          break;
        case RtkRoomEventName.onSocketConnectionUpdate:
          final state =
              SocketConnectionState.fromMap(callDetails.args["state"]);
          for (final element in _listeners) {
            element.onSocketConnectionUpdate(state);
          }
          break;

        case RtkRoomEventName.unknown:
          throw Exception("Unkown method called");
      }
      _sendingCallbacksInProgress = false;
      callAttachDetachListenerAfterProcessing();
    });
  }

  @override
  void detach(RtkMeetingRoomEventListener listener) {
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
