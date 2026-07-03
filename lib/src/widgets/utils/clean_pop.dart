import 'package:realtimekit_ui/src/data/manage_listeners.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RtkUtils {
  final BuildContext context;
  RtkUtils(this.context);
  Future<void> cleanAndPopUiKit(WidgetRef ref) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    RtkListenerManager.instance.unregisterRtkListeners();
    rtkMeeting.cleanAllNativeListeners();
    rtkMeeting.removeMeetingRoomEventListener(
      ref.read(routerNotifier.notifier),
    );
    // Always release the native meeting on exit. The native RealtimeKit client
    // is a single long-lived instance; without release() it stays in an
    // already-initialized state and the next init() never completes, leaving a
    // re-joined meeting stuck on the loading screen until the app is restarted.
    await rtkMeeting.release();
    navigator.popUntil((route) => route.isFirst);
  }

  Future<void> leave(WidgetRef ref, {bool release = false}) async {
    await cleanAndPopUiKit(ref);
  }
}
