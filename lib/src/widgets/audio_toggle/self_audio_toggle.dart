import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/data/models/media_toggle_state.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_bottom_nav_button.dart';
import 'package:realtimekit_ui/src/widgets/core/button/rtk_elevated_button.dart';
import 'package:realtimekit_ui/src/widgets/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/widgets/core/rtk_uikit_component.dart';

import '../../di/riverpod_di.dart';

class RtkSelfAudioToggleButton extends ConsumerStatefulWidget
    with UsesStatusColor {
  RtkSelfAudioToggleButton({
    required this.meeting,
    RtkDesignTokens? individualDesignToken,
    this.onAudioToggle,
    this.iconSize,
    this.iconColor,
    this.showLabel = false,
    super.key,
  }) : designToken = individualDesignToken ?? globalDesignToken;

  final VoidCallback? onAudioToggle;
  final RtkDesignTokens designToken;
  final RealtimekitClient meeting;
  final double? iconSize;
  final Color? iconColor;
  final bool showLabel;

  @override
  ConsumerState<RtkSelfAudioToggleButton> createState() =>
      _RtkSelfAudioToggleButtonState();

  @override
  Color get errorColor => designToken.colorToken.danger;

  @override
  Color get successColor => designToken.colorToken.success;

  @override
  Color get warningColor => designToken.colorToken.warning;
}

class _RtkSelfAudioToggleButtonState
    extends ConsumerState<RtkSelfAudioToggleButton> {
  SelfAudioNotifier? _selfAudioNotifier;
  @override
  void initState() {
    _selfAudioNotifier = SelfAudioNotifier(widget.meeting);
    widget.meeting.addSelfEventListener(_selfAudioNotifier!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _selfAudioNotifier!,
      builder: (context, value, child) => _buildToggleButton(value),
    );
  }

  void _onAudioToggle() {
    _selfAudioNotifier!.startAudioToggle();
    if (_selfAudioNotifier!.value == MediaToggleState.on) {
      widget.meeting.localUser.disableAudio();
    } else {
      widget.meeting.localUser.enableAudio();
    }
  }

  Widget _buildToggleButton(MediaToggleState audioToggleState) {
    if (audioToggleState == MediaToggleState.inProgress) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: widget.designToken.colorToken.textColor.shade800,
        ),
      );
    }

    final value = audioToggleState == MediaToggleState.on;
    final isMicGranted = widget.meeting.localUser.isMicrophonePermissionGranted;
    final isMicAllowed = widget.meeting.permissions.media.audio ==
            MediaPermission.allowed ||
        (widget.meeting.permissions.media.audio == MediaPermission.canRequest &&
            ref.watch(stageStatusNotifier) == StageStatus.onStage);

    /// If user is allowed to use mic as per preset permissions
    if (isMicAllowed) {
      /// If user wants to show label (as used in bottom nav bar button)
      if (widget.showLabel) {
        return RtkBottomNavButton(
          icon: value
              ? const Icon(DyteIcons.mic_on)
              : Icon(DyteIcons.mic_off,
                  color: widget.iconColor ?? widget.errorColor),
          label: value ? RtkStrings.micOn : RtkStrings.micOff,
          disabled: !isMicGranted,
          onTap: () {
            _onAudioToggle();
            widget.onAudioToggle?.call();
          },
        );
      } else {
        return RtkButtons.icon(
          value
              ? Icon(DyteIcons.mic_on, color: widget.iconColor)
              : Icon(
                  DyteIcons.mic_off,
                  color: widget.iconColor ?? widget.errorColor,
                ),
          designToken: widget.designToken,
          iconSize: widget.iconSize,
          isDisabled: !isMicGranted,
          onPressed: () {
            _onAudioToggle();
            widget.onAudioToggle?.call();
          },
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    _selfAudioNotifier?.dispose();
    widget.meeting.removeSelfEventListener(_selfAudioNotifier!);
    _selfAudioNotifier = null;
    super.dispose();
  }
}

class SelfAudioNotifier extends ValueNotifier<MediaToggleState>
    implements RtkSelfEventListener {
  final RealtimekitClient meeting;
  SelfAudioNotifier(this.meeting)
      : super(meeting.localUser.audioEnabled
            ? MediaToggleState.on
            : MediaToggleState.off);

  void startAudioToggle() {
    Future.microtask(() => value = MediaToggleState.inProgress);
  }

  @override
  void onAudioUpdate(bool audioEnabled) {
    value = audioEnabled ? MediaToggleState.on : MediaToggleState.off;
  }

  @override
  void onVideoUpdate(bool videoEnabled) {}

  @override
  void onAudioDevicesUpdated(List<AudioDevice> audioDevices) {}

  @override
  void onAudioDeviceChanged(AudioDevice audioDevice) {}

  @override
  void onMeetingRoomJoinedWithoutCameraPermission() {}

  @override
  void onMeetingRoomJoinedWithoutMicPermission() {}

  @override
  void onRemovedFromMeeting() {}

  @override
  void onWaitListStatusUpdate(WaitlistStatus waitListStatus) {}

  @override
  void onVideoDeviceChanged(VideoDevice videoDevice) {}

  @override
  void onScreenShareStartFailed(String reason) {}

  @override
  void onPermissionsUpdated(SelfPermissions permissions) {}

  @override
  void onUpdate(RtkSelfParticipant participant) {
    // TODO: implement onUpdate
  }

  @override
  void onScreenShareUpdate(bool isEnabled) {}

  @override
  void onPinned() {}

  @override
  void onUnpinned() {}
}
