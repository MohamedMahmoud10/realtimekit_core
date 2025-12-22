import 'dart:async';
import 'dart:convert';

import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';
import 'package:realtimekit_core_platform_interface/src/enums/rtk_recording_events.dart';
import 'package:flutter/services.dart';

import '../types/call_details.dart';

class RtkRecordingListenerChannel
    extends RtkListenerChannel<RtkRecordingEventListener> {
  final EventChannel _channel;

  late StreamSubscription _subscription;
  RtkRecordingListenerChannel(this._channel);

  final List<RtkRecordingEventListener> _listeners = [];

  @override
  Future<void> init(MethodChannel coreMethodChannel) async {
    _subscription = _handleRecordingEvents();
    await coreMethodChannel.invokeMethod('addRecordingEventListener');
  }

  bool _sendingCallbacksInProgress = false;
  final List<RtkRecordingEventListener> _addListenerAfterProcessing = [];
  final List<RtkRecordingEventListener> _removeListenerAfterProcessing = [];

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
  void attach(RtkRecordingEventListener listener) {
    if (!_listeners.contains(listener)) {
      if (_sendingCallbacksInProgress) {
        _addListenerAfterProcessing.add(listener);
        return;
      } else {
        _listeners.add(listener);
      }
    }
  }

  StreamSubscription _handleRecordingEvents() {
    return _channel.receiveBroadcastStream().listen((event) {
      final callDetails = CallDetails.fromJson(json.encode(event));
      final recEvent = RtkRecordingEvents.fromString(callDetails.name);
      _sendingCallbacksInProgress = true;

      switch (recEvent) {
        case RtkRecordingEvents.onRecordingStateChanged:
          final oldStateMap = (callDetails.args as Map)['oldState']['state'];
          final newStateMap = (callDetails.args as Map)['newState']['state'];
          final oldState = RecordingState.fromName(oldStateMap.toString());
          final newState = RecordingState.fromName(newStateMap.toString());
          for (final element in _listeners) {
            element.onRecordingStateChanged(oldState, newState);
          }
          break;
        case RtkRecordingEvents.unknown:
          throw Exception("Unkown method called");
      }
      _sendingCallbacksInProgress = false;
      callAttachDetachListenerAfterProcessing();
    });
  }

  @override
  void detach(RtkRecordingEventListener listener) async {
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
