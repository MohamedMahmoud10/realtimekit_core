import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/data/states/local_user_states.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:realtimekit_ui/src/pages/setup/settings_page.dart';
import 'package:realtimekit_ui/src/routes/router.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:realtimekit_ui/src/tokens/color/status_color.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_icon_button.dart';

import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text_field.dart';

import 'package:realtimekit_ui/src/widgets/atoms/vh_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/widgets/molecules/rtk_snackbar.dart';

class RtkSetupScreen extends ConsumerStatefulWidget {
  final AudioDevice? selectedAudioDevice;
  final VideoDevice? selectedVideoDevice;
  const RtkSetupScreen(this.selectedAudioDevice, this.selectedVideoDevice,
      {super.key});

  @override
  ConsumerState<RtkSetupScreen> createState() => _SetupPageState();
}

class _SetupPageState extends ConsumerState<RtkSetupScreen> {
  final _userNameController =
      TextEditingController(text: rtkMeeting.localUser.name);

  final mediaPermissions = rtkMeeting.permissions.media;

  @override
  void initState() {
    super.initState();

    ref.read(localUserSettingsProvider.notifier).isAudioEnabled =
        meetingInfo.enableAudio &&
            mediaPermissions.audio == MediaPermission.allowed &&
            rtkMeeting.localUser.isMicrophonePermissionGranted;
    ref.read(localUserSettingsProvider.notifier).isVideoEnabled =
        rtkMeeting.localUser.isCameraPermissionGranted &&
            meetingInfo.enableVideo &&
            mediaPermissions.video.permission == MediaPermission.allowed;
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(
        localUserSettingsProvider.select((value) => value is OnVideoUpdate));
    final bool nameIsEmpty =
        ref.watch(editNameProvider.select((name) => name.isEmpty));
    final theme = AppTheme(globalDesignToken.colorToken).theme;

    return PopScope(
      onPopInvokedWithResult: (didPop, _) => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: const [RtkReleaseResourcesButton()],
        ),
        body: SafeArea(
          child: OrientationBuilder(builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return _VerticalSetupPage(
                widget: widget,
                userNameController: _userNameController,
                theme: theme,
                ref: ref,
                nameIsEmpty: nameIsEmpty,
              );
            } else {
              return _HorizontalSetupPage(
                widget: widget,
                userNameController: _userNameController,
                theme: theme,
                ref: ref,
                nameIsEmpty: nameIsEmpty,
              );
            }
          }),
        ),
      ),
    );
  }
}

class _HorizontalSetupPage extends StatelessWidget {
  const _HorizontalSetupPage({
    super.key,
    required this.widget,
    required TextEditingController userNameController,
    required this.theme,
    required this.ref,
    required this.nameIsEmpty,
  }) : _userNameController = userNameController;

  final RtkSetupScreen widget;
  final TextEditingController _userNameController;
  final ThemeData theme;
  final WidgetRef ref;
  final bool nameIsEmpty;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: context.adjust(24)),
          child: SizedBox(
            height: context.adjust(240),
            width: context.adjust(200),
            child: RtkParticipantTile(rtkMeeting.localUser),
          ),
        ),
        hspace4,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SetupScreenControlButtons(
              selectedAudioDevice: widget.selectedAudioDevice,
              selectedVideoDevice: widget.selectedVideoDevice,
            ),
            vspace3,
            RtkText(RtkStrings.joinInAs),
            vspace1,
            RtkTextField(
              key: const Key('name_text_field'),
              controller: _userNameController,
              hintText: RtkStrings.enterYourName,
              hintStyle: theme.textTheme.titleMedium,
              onChanged: (name) {
                ref.read(editNameProvider.notifier).onChanged(name.trim());
              },
              enabled: rtkMeeting.permissions.miscellaneous.canEditDisplayName,
              height: context.adjust(44),
              width: context.adjust(200),
            ),
            vspace2,
            RtkJoinButton(
              isDisabled: nameIsEmpty,
              meeting: rtkMeeting,
              height: context.adjust(48),
              width: context.adjust(200),
              onMeetingJoined: () {
                rtkMeeting.localUser
                    .setDisplayName(_userNameController.text.trim());
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _VerticalSetupPage extends StatelessWidget {
  const _VerticalSetupPage({
    super.key,
    required this.widget,
    required TextEditingController userNameController,
    required this.theme,
    required this.ref,
    required this.nameIsEmpty,
  }) : _userNameController = userNameController;

  final RtkSetupScreen widget;
  final TextEditingController _userNameController;
  final ThemeData theme;
  final WidgetRef ref;
  final bool nameIsEmpty;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          vspace2,
          SizedBox(
            height: context.adjust(320),
            width: context.adjust(240),
            child: RtkParticipantTile(rtkMeeting.localUser),
          ),
          vspace2,
          SetupScreenControlButtons(
            selectedAudioDevice: widget.selectedAudioDevice,
            selectedVideoDevice: widget.selectedVideoDevice,
          ),
          vspace3,
          RtkText(RtkStrings.joinInAs),
          vspace1,
          RtkTextField(
            key: const Key('name_text_field'),
            controller: _userNameController,
            hintText: RtkStrings.enterYourName,
            hintStyle: theme.textTheme.titleMedium,
            onChanged: (name) {
              ref.read(editNameProvider.notifier).onChanged(name.trim());
            },
            enabled: rtkMeeting.permissions.miscellaneous.canEditDisplayName,
            height: context.adjust(44),
            width: context.adjust(300),
          ),
          vspace2,
          RtkJoinButton(
            isDisabled: nameIsEmpty,
            meeting: rtkMeeting,
            height: context.adjust(48),
            width: context.adjust(300),
            onMeetingJoined: () {
              rtkMeeting.localUser
                  .setDisplayName(_userNameController.text.trim());
            },
          ),
        ],
      ),
    );
  }
}

class SetupScreenControlButtons extends StatelessWidget {
  final AudioDevice? selectedAudioDevice;
  final VideoDevice? selectedVideoDevice;

  const SetupScreenControlButtons(
      {this.selectedAudioDevice, this.selectedVideoDevice, super.key});

  @override
  Widget build(BuildContext context) {
    final isCameraGranted = rtkMeeting.localUser.isCameraPermissionGranted;
    final isMicGranted = rtkMeeting.localUser.isMicrophonePermissionGranted;
    final colorScheme =
        AppTheme(globalDesignToken.colorToken).theme.colorScheme;
    final mediaPermissions = rtkMeeting.permissions.media;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (mediaPermissions.audio == MediaPermission.allowed)
          GestureDetector(
            onTap: !isMicGranted
                ? () {
                    showBottomSheetWithWidget(
                      context,
                      _getSnackbarMessage(
                        'Please grant microphone permission from Settings to enable audio',
                      ),
                    );
                  }
                : null,
            child: Container(
              height: context.adjust(48),
              width: context.adjust(48),
              decoration: BoxDecoration(
                color: globalDesignToken.colorToken.backgroundColor.shade900,
                borderRadius: BorderRadius.circular(
                  borderToken.getRadius(BorderSize.one),
                ),
              ),
              child: RtkSelfAudioToggleButton(meeting: rtkMeeting),
            ),
          ),
        hspace3,
        if (mediaPermissions.video.permission == MediaPermission.allowed)
          GestureDetector(
            onTap: !isCameraGranted
                ? () {
                    showBottomSheetWithWidget(
                        context,
                        _getSnackbarMessage(
                            'Please grant camera permission from Settings to enable video'));
                  }
                : null,
            child: Container(
                height: context.adjust(48),
                width: context.adjust(48),
                decoration: BoxDecoration(
                  color: globalDesignToken.colorToken.backgroundColor.shade900,
                  borderRadius: BorderRadius.circular(
                    borderToken.getRadius(BorderSize.one),
                  ),
                ),
                child: RtkSelfVideoToggleButton(
                  meeting: rtkMeeting,
                )),
          ),
        hspace3,
        if (mediaPermissions.audio == MediaPermission.allowed ||
            mediaPermissions.video.permission == MediaPermission.allowed ||
            selectedAudioDevice != null ||
            selectedVideoDevice != null)
          RtkIconButton(
            onPressed: () {
              RtkRouter.of(context).push(SetupSettingsPage());
            },
            icon: Icon(
              DyteIcons.settings,
              color: colorScheme.onSecondary,
            ),
          ),
      ],
    );
  }

  Widget _getSnackbarMessage(String message) {
    return Row(
      children: [
        const Icon(
          DyteIcons.warning,
          color: StatusColor.warning,
          size: 20,
        ),
        hspace2,
        Expanded(
            child: Text(message,
                style: AppTheme(globalDesignToken.colorToken)
                    .theme
                    .textTheme
                    .bodyMedium)),
      ],
    );
  }
}
