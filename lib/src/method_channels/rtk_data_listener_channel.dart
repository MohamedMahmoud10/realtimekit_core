import 'dart:async';
import 'dart:convert';

import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';
import 'package:realtimekit_core_platform_interface/src/enums/rtk_data_events.dart';
import 'package:realtimekit_core_platform_interface/src/types/call_details.dart';
import 'package:flutter/services.dart';

class RtkDataListenerChannel extends RtkListenerChannel<RtkDataEventListener> {
  final EventChannel _channel;
  final RtkPluginApi _pluginApi;
  final RtkJoinedMeetingParticipantApi _joinedParticipantApi;
  final RtkMeetingParticipantApi _meetingParticipantApi;
  late StreamSubscription _subscription;
  final RtkWaitlistedParticipantApi _waitlistedParticipantApi;

  RtkDataListenerChannel(
    this._waitlistedParticipantApi,
    this._channel,
    this._pluginApi,
    this._joinedParticipantApi,
    this._meetingParticipantApi,
  );

  final List<RtkDataEventListener> _listeners = [];

  @override
  Future<void> init(MethodChannel coreMethodChannel) async {
    _subscription = _handleDataEvents();
    await coreMethodChannel.invokeMethod('addDataUpdateListener');
  }

  bool _sendingCallbacksInProgress = false;
  final List<RtkDataEventListener> _addListenerAfterProcessing = [];
  final List<RtkDataEventListener> _removeListenerAfterProcessing = [];

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
  void attach(RtkDataEventListener listener) {
    if (!_listeners.contains(listener)) {
      if (_sendingCallbacksInProgress) {
        _addListenerAfterProcessing.add(listener);
        return;
      } else {
        _listeners.add(listener);
      }
    }
  }

  StreamSubscription _handleDataEvents() {
    return _channel.receiveBroadcastStream().listen((event) {
      final callDetails = CallDetails.fromJson(json.encode(event));
      final roomEvent = RtkDataEventsName.fromString(callDetails.name);
      _sendingCallbacksInProgress = true;

      switch (roomEvent) {
        case RtkDataEventsName.onMetaUpdate:
          final meta = callDetails.args as Map;
          final roomName = meta['roomName'] as String;
          final meetingTitle = meta['meetingTitle'] as String;
          final meetingStartedTimestamp =
              meta['meetingStartedTimestamp'] as String;
          final meetingType =
              RtkMeetingType.fromName(meta['roomType'] as String);
          final designToken = RtkDesignTokens.fromMap(meta['designToken']);

          for (final element in _listeners) {
            element.onMetaUpdate(
              roomName,
              meetingTitle,
              meetingStartedTimestamp,
              meetingType,
              designToken,
            );
          }
          break;
        case RtkDataEventsName.onSelfPermissionsUpdate:
          final permissions = SelfPermissions.fromJson(
              json.encode(callDetails.args['selfPermissions']));
          for (final element in _listeners) {
            element.onSelfPermissionsUpdate(permissions);
          }

          break;
        case RtkDataEventsName.onPluginsUpdates:
          final plugins = callDetails.args['plugins'] as List;
          final pluginList = plugins
              .map((e) => RtkPlugin.fromJson(
                    json.encode(e),
                    _pluginApi,
                  ))
              .toList(growable: false);
          for (final element in _listeners) {
            element.onPluginUpdate(pluginList);
          }
          break;
        case RtkDataEventsName.onScreenShareUpdate:
          final screenShares = callDetails.args['screenShares'] as List;
          final screenSharesList = screenShares
              .map((e) => RtkRemoteParticipant.fromJson(
                  json.encode(e),
                  _joinedParticipantApi,
                  _meetingParticipantApi,
                  _waitlistedParticipantApi))
              .toList(growable: false);
          for (final element in _listeners) {
            element.onScreenShareUpdate(screenSharesList);
          }
          break;
        case RtkDataEventsName.onLivestreamUpdate:
          final map = callDetails.args['livestreamData'];
          final livestreamData = RtkLivestreamData.fromJson(
            json.encode(map),
          );

          for (final element in _listeners) {
            element.onLivestreamUpdate(livestreamData);
          }
          break;
        case RtkDataEventsName.unknown:
          throw Exception("Unkown method called");
      }
      _sendingCallbacksInProgress = false;
      callAttachDetachListenerAfterProcessing();
    });
  }

  @override
  void detach(RtkDataEventListener listener) {
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
