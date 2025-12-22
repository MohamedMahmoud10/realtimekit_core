import 'package:flutter/services.dart';
import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';

abstract class RtkListenerChannel<T extends RtkListener> {
  Future<void> init(MethodChannel coreMethodChannel);
  void attach(T listener);
  void detach(T listener);
  Future<void> dispose();
}
