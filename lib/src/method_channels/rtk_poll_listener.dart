import 'dart:async';
import 'dart:convert';

import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';
import 'package:realtimekit_core_platform_interface/src/enums/rtk_poll_events.dart';
import 'package:realtimekit_core_platform_interface/src/types/call_details.dart';
import 'package:flutter/services.dart';

class RtkPollListenerChannel extends RtkListenerChannel<RtkPollsEventListener> {
  final EventChannel _channel;
  late StreamSubscription _subscription;
  RtkPollListenerChannel(this._channel);

  final List<RtkPollsEventListener> _listeners = [];

  @override
  Future<void> init(MethodChannel coreMethodChannel) async {
    _subscription = _handlePollsEvents();
    await coreMethodChannel.invokeMethod('addPollsEventListener');
  }

  bool _sendingCallbacksInProgress = false;
  final List<RtkPollsEventListener> _addListenerAfterProcessing = [];
  final List<RtkPollsEventListener> _removeListenerAfterProcessing = [];

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
  void attach(RtkPollsEventListener listener) {
    if (!_listeners.contains(listener)) {
      if (_sendingCallbacksInProgress) {
        _addListenerAfterProcessing.add(listener);
        return;
      } else {
        _listeners.add(listener);
      }
    }
  }

  StreamSubscription _handlePollsEvents() {
    return _channel.receiveBroadcastStream().listen((event) {
      final callDetails = CallDetails.fromJson(json.encode(event));
      final roomEvent = RtkPollEventsName.fromString(callDetails.name);
      _sendingCallbacksInProgress = true;

      switch (roomEvent) {
        case RtkPollEventsName.onNewPoll:
          final poll = (callDetails.args as Map)['poll'];
          final rtkPoll = Poll.fromJson(json.encode(poll));
          for (final element in _listeners) {
            element.onNewPoll(rtkPoll);
          }
          break;
        case RtkPollEventsName.onPollUpdates:
          final polls = (callDetails.args as Map)['pollItems'] as List;
          final rtkPollList =
              polls.map((e) => Poll.fromJson(json.encode(e))).toList();
          for (final element in _listeners) {
            element.onPollUpdates(rtkPollList);
          }
          break;
        case RtkPollEventsName.onPollUpdate:
          final poll = (callDetails.args as Map)['poll'];
          final rtkPoll = Poll.fromJson(json.encode(poll));
          for (final element in _listeners) {
            element.onPollUpdate(rtkPoll);
          }
          break;
        case RtkPollEventsName.unknown:
          throw Exception("Unkown method called");
      }
      _sendingCallbacksInProgress = false;
      callAttachDetachListenerAfterProcessing();
    });
  }

  @override
  void detach(RtkPollsEventListener listener) {
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
    RtkPollController.instance.dispose();
    return;
  }
}
