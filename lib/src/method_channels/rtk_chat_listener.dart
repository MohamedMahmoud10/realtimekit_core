import 'dart:async';
import 'dart:convert';

import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';
import 'package:realtimekit_core_platform_interface/src/enums/rtk_chat_events_name.dart';
import 'package:realtimekit_core_platform_interface/src/types/call_details.dart';
import 'package:flutter/services.dart';

class RtkChatListenerChannel extends RtkListenerChannel<RtkChatEventListener> {
  final EventChannel _channel;
  late StreamSubscription _subscription;

  RtkChatListenerChannel(this._channel);

  final List<RtkChatEventListener> _listeners = [];

  @override
  Future<void> init(MethodChannel coreMethodChannel) async {
    _subscription = _handleChatEvents();
    await coreMethodChannel.invokeMethod('addChatListener');
  }

  bool _sendingCallbacksInProgress = false;
  final List<RtkChatEventListener> _addListenerAfterProcessing = [];
  final List<RtkChatEventListener> _removeListenerAfterProcessing = [];

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
  void attach(RtkChatEventListener listener) {
    if (!_listeners.contains(listener)) {
      if (_sendingCallbacksInProgress) {
        _addListenerAfterProcessing.add(listener);
        return;
      } else {
        _listeners.add(listener);
      }
    }
  }

  StreamSubscription<dynamic> _handleChatEvents() {
    return _channel.receiveBroadcastStream().listen((event) {
      final callDetails = CallDetails.fromJson(json.encode(event));
      final roomEvent = RtkChatEventsName.fromString(callDetails.name);
      _sendingCallbacksInProgress = true;

      switch (roomEvent) {
        case RtkChatEventsName.onChatUpdates:
          final chats = (callDetails.args as Map)['messages'] as List;
          final rtkChatList =
              chats.map((e) => ChatMessage.fromJson(json.encode(e))).toList();
          for (final element in _listeners) {
            element.onChatUpdates(rtkChatList);
          }
          break;
        case RtkChatEventsName.onNewChatMessage:
          final chat = (callDetails.args as Map)['message'];
          final rtkChat = ChatMessage.fromJson(json.encode(chat));
          for (final element in _listeners) {
            element.onNewChatMessage(rtkChat);
          }
          break;
        case RtkChatEventsName.unknown:
          throw Exception("Unkown method called");
      }
      _sendingCallbacksInProgress = false;
      callAttachDetachListenerAfterProcessing();
    });
  }

  @override
  void detach(RtkChatEventListener listener) {
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
    RtkChatController.instance.dispose();
    return;
  }
}
