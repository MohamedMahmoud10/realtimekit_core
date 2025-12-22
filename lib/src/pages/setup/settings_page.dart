import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_app_bar.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';
import 'package:realtimekit_ui/src/widgets/atoms/vh_space.dart';
import 'package:realtimekit_ui/src/widgets/molecules/audio_devices_loader.dart';
import 'package:realtimekit_ui/src/widgets/molecules/video_devices_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SetupSettingsPage extends ConsumerWidget {
  SetupSettingsPage({
    super.key,
  });

  final mediaPermissions = rtkMeeting.permissions.media;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: RtkAppBar(
        hasLeading: false,
        actions: [
          IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(DyteIcons.dismiss),
          )
        ],
        title: RtkText(RtkStrings.settings),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: MediaQuery.of(context).orientation == Orientation.portrait
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          height: context.adjust(320),
                          width: context.adjust(240),
                          child: _getPeerView(),
                        ),
                      ),
                      vspace3,
                      const DeviceLoader(),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          height: context.adjust(320),
                          width: context.adjust(240),
                          child: _getPeerView(),
                        ),
                      ),
                      hspace3,
                      const DeviceLoader(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _getPeerView() {
    return RtkParticipantTile(rtkMeeting.localUser);
  }
}

class DeviceLoader extends ConsumerWidget {
  const DeviceLoader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localUserApi = ref.watch(localUserSettingsProvider.notifier);
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    final isCameraGranted = rtkMeeting.localUser.isCameraPermissionGranted;
    final isMicGranted = rtkMeeting.localUser.isMicrophonePermissionGranted;

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCameraGranted && localUserApi.isVideoEnabled) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.width * .15),
              child: RtkText(
                RtkStrings.camera,
                rtkTextStyle: theme.textTheme.titleMedium,
              ),
            ),
            vspace1,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.width * .15),
              child: const VideoDevicesLoader(),
            ),
            vspace3,
          ],
          ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.width * .15),
              child: RtkText(
                RtkStrings.microphoneInput,
                rtkTextStyle: theme.textTheme.titleMedium,
              ),
            ),
            vspace1,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.width * .15),
              child: const AudioDevicesLoader(),
            ),
          ]
        ]);
  }
}
