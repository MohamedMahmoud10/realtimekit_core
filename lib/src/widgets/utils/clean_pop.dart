import 'package:realtimekit_ui/src/data/manage_listeners.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';
import 'package:realtimekit_ui/src/widgets/molecules/snackbar.dart';
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
    navigator.popUntil((route) => route.isFirst);
  }

  Future<void> leave(WidgetRef ref, {bool release = false}) async {
    if (release) {
      final result = await rtkMeeting.release();
      if (result) {
        await cleanAndPopUiKit(ref);
      } else {
        showSnackbarWidget(
          context,
          const RtkText('Failed to leave the meeting'),
        );
      }
    } else {
      await cleanAndPopUiKit(ref);
    }
  }
}
