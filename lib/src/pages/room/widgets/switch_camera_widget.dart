import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/src/data/states/local_user_states.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_icon_button.dart';

import '../../../../realtimekit_ui.dart';

class SwitchCameraWidget extends ConsumerWidget {
  const SwitchCameraWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget cameraToggler = RtkIconButton(
      icon: const Icon(DyteIcons.camera_switch),
      onPressed: () async {
        // TODO: improve the logic
        final selectedVideoDevice =
            await rtkMeeting.localUser.getSelectedVideoDevice();
        final videoDevices = await rtkMeeting.localUser.getVideoDevices();
        videoDevices.remove(selectedVideoDevice);

        rtkMeeting.localUser.switchCamera();
      },
    );
    ref.watch(
        localUserSettingsProvider.select((value) => value is OnVideoUpdate));

    // Return the widget as per initial state.
    return rtkMeeting.localUser.videoEnabled ? cameraToggler : Container();
  }
}
