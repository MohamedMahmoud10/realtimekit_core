import 'dart:async';
import 'dart:convert';

import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';
import 'package:realtimekit_core_platform_interface/src/enums/rtk_plugin_events_listener_method.dart';
import 'package:realtimekit_core_platform_interface/src/types/call_details.dart';
import 'package:flutter/services.dart';

class RtkPluginsListenerChannel
    extends RtkListenerChannel<RtkPluginsEventListener> {
  final EventChannel _channel;
  final RtkPluginApi api;
  final List<RtkPluginsEventListener> _listeners = [];

  late StreamSubscription _subscription;

  RtkPluginsListenerChannel(this._channel, this.api);

  @override
  Future<void> init(MethodChannel coreMethodChannel) async {
    _subscription = __handlePluginEvents();
    await coreMethodChannel.invokeMethod('addPluginEventListener');
  }

  bool _sendingCallbacksInProgress = false;
  final List<RtkPluginsEventListener> _addListenerAfterProcessing = [];
  final List<RtkPluginsEventListener> _removeListenerAfterProcessing = [];

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
  void attach(RtkPluginsEventListener listener) {
    if (!_listeners.contains(listener)) {
      if (_sendingCallbacksInProgress) {
        _addListenerAfterProcessing.add(listener);
        return;
      } else {
        _listeners.add(listener);
      }
    }
  }

  StreamSubscription __handlePluginEvents() {
    return _channel.receiveBroadcastStream().listen((call) async {
      final callDetails = CallDetails.fromJson(json.encode(call));
      final listenerMethod =
          RtkPluginEventsMethodNames.fromName(callDetails.name);
      _sendingCallbacksInProgress = true;

      switch (listenerMethod) {
        case RtkPluginEventsMethodNames.onPluginActivated:
          final pluginMap = callDetails.args;
          for (final element in _listeners) {
            element.onPluginActivated(
                RtkPlugin.fromJson(json.encode(pluginMap), api));
          }
          break;
        case RtkPluginEventsMethodNames.onPluginMessage:
          for (final listener in _listeners) {
            final args = callDetails.args;
            final pluginMap =
                RtkPlugin.fromJson(json.encode(args["plugin"]), api);
            final eventName = args["eventName"] as String;
            final data = args["data"] as String;
            // This can break if the plugin is not sending a string
            listener.onPluginMessage(pluginMap, eventName, data);
          }
          break;
        case RtkPluginEventsMethodNames.onPluginFileRequest:
          for (final listener in _listeners) {
            final pluginMap = callDetails.args as Map<String, dynamic>;
            final plugin = RtkPlugin.fromJson(json.encode(pluginMap), api);
            listener.onPluginFileRequest(plugin);
          }
          break;
        case RtkPluginEventsMethodNames.onPluginDeactivated:
          final pluginMap = callDetails.args;
          for (final element in _listeners) {
            element.onPluginDeactivated(
                RtkPlugin.fromJson(json.encode(pluginMap), api));
          }
          break;
        default:
          throw Exception("Method not implemented");
      }
      _sendingCallbacksInProgress = false;
      callAttachDetachListenerAfterProcessing();
    });
  }

  @override
  void detach(RtkPluginsEventListener listener) {
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
