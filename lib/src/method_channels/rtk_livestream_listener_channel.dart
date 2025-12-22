import 'dart:async';
import 'dart:convert';

import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';
import 'package:realtimekit_core_platform_interface/src/enums/rtk_livestream_events_name.dart';
import 'package:flutter/services.dart';

import '../types/call_details.dart';

class RtkLivestreamListenerChannel
    extends RtkListenerChannel<RtkLivestreamEventListener> {
  final EventChannel _channel;

  late StreamSubscription _subscription;

  RtkLivestreamListenerChannel(this._channel);

  final List<RtkLivestreamEventListener> _listeners = [];

  @override
  Future<void> init(MethodChannel coreMethodChannel) async {
    _subscription = _handleLivestreamEvents();
    await coreMethodChannel.invokeMethod('addLivestreamEventListener');
  }

  bool _sendingCallbacksInProgress = false;
  final List<RtkLivestreamEventListener> _addListenerAfterProcessing = [];
  final List<RtkLivestreamEventListener> _removeListenerAfterProcessing = [];

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
  void attach(RtkLivestreamEventListener listener) {
    if (!_listeners.contains(listener)) {
      if (_sendingCallbacksInProgress) {
        _addListenerAfterProcessing.add(listener);
        return;
      } else {
        _listeners.add(listener);
      }
    }
  }

  StreamSubscription _handleLivestreamEvents() {
    return _channel.receiveBroadcastStream().listen((event) {
      final callDetails = CallDetails.fromJson(json.encode(event));
      final livestreamEvent =
          RtkLivestreamEventsName.fromName(callDetails.name);
      _sendingCallbacksInProgress = true;

      switch (livestreamEvent) {
        case RtkLivestreamEventsName.onLiveStreamStarting:
          for (final element in _listeners) {
            element.onLiveStreamStarting();
          }
          break;
        case RtkLivestreamEventsName.onLiveStreamStarted:
          for (final element in _listeners) {
            element.onLiveStreamStarted();
          }
          break;
        case RtkLivestreamEventsName.onLiveStreamStateUpdate:
          final Map map = callDetails.args['data'] as Map;
          final RtkLivestreamData data =
              RtkLivestreamData.fromJson(json.encode(map));
          for (final element in _listeners) {
            element.onLiveStreamStateUpdate(data);
          }
          break;
        case RtkLivestreamEventsName.onViewerCountUpdated:
          final count = callDetails.args['count'] as int;
          for (final element in _listeners) {
            element.onViewerCountUpdated(count);
          }
          break;
        case RtkLivestreamEventsName.onLiveStreamEnding:
          for (final element in _listeners) {
            element.onLiveStreamEnding();
          }
          break;
        case RtkLivestreamEventsName.onLiveStreamEnded:
          for (final element in _listeners) {
            element.onLiveStreamEnded();
          }
          break;
        case RtkLivestreamEventsName.onLiveStreamErrored:
          for (final element in _listeners) {
            element.onLiveStreamErrored();
          }
          break;
        case RtkLivestreamEventsName.onStageCountUpdated:
          for (final element in _listeners) {
            element.onStageCountUpdated(callDetails.args['count'] as int);
          }
          break;
        case RtkLivestreamEventsName.unknown:
          throw Exception("Unkown method called");
      }
      _sendingCallbacksInProgress = false;
      callAttachDetachListenerAfterProcessing();
    });
  }

  @override
  void detach(RtkLivestreamEventListener listener) {
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
