import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/data/models/media_toggle_state.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_bottom_nav_button.dart';
import 'package:realtimekit_ui/src/widgets/core/core.dart';
import 'package:realtimekit_ui/src/widgets/core/rtk_uikit_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RtkSelfVideoToggleButton extends ConsumerStatefulWidget
    with UsesStatusColor {
  RtkSelfVideoToggleButton({
    required this.meeting,
    RtkDesignTokens? individualDesignToken,
    this.onVideoToggle,
    this.iconSize,
    this.iconColor,
    this.showLabel = false,
    super.key,
  }) : designTokens = individualDesignToken ?? globalDesignToken;

  final VoidCallback? onVideoToggle;
  final RtkDesignTokens designTokens;
  final RealtimekitClient meeting;
  final double? iconSize;
  final Color? iconColor;
  final bool showLabel;

  @override
  ConsumerState<RtkSelfVideoToggleButton> createState() =>
      _RtkSelfVideoToggleButtonState();

  @override
  Color get errorColor => designTokens.colorToken.danger;

  @override
  Color get successColor => designTokens.colorToken.success;

  @override
  Color get warningColor => designTokens.colorToken.warning;
}

class _RtkSelfVideoToggleButtonState
    extends ConsumerState<RtkSelfVideoToggleButton> {
  SelfVideoNotifier? _selfVideoNotifier;
  @override
  void initState() {
    _selfVideoNotifier = SelfVideoNotifier(widget.meeting);
    widget.meeting.addSelfEventListener(_selfVideoNotifier!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _selfVideoNotifier!,
      builder: (context, value, child) => _buildToggleButton(value),
    );
  }

  void _onVideoToggle() {
    _selfVideoNotifier!.startVideoToggle();
    if (_selfVideoNotifier!.value == MediaToggleState.on) {
      widget.meeting.localUser.disableVideo();
    } else {
      widget.meeting.localUser.enableVideo();
    }
  }

  Widget _buildToggleButton(MediaToggleState videoToggleState) {
    if (videoToggleState == MediaToggleState.inProgress) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: widget.designTokens.colorToken.textColor.shade600,
        ),
      );
    }
    final value = videoToggleState == MediaToggleState.on;
    final isCameraGranted = widget.meeting.localUser.isCameraPermissionGranted;

    final isCameraAllowed = widget.meeting.permissions.media.video.permission ==
            MediaPermission.allowed ||
        (widget.meeting.permissions.media.video.permission ==
                MediaPermission.canRequest &&
            ref.watch(stageStatusNotifier) == StageStatus.onStage);

    /// If user is allowed to use camera as per preset permissions
    if (isCameraAllowed) {
      /// If user wants to show label (as used in bottom nav bar button)
      if (widget.showLabel) {
        return Center(
          child: RtkBottomNavButton(
            icon: value
                ? const Icon(DyteIcons.video_on)
                : Icon(
                    DyteIcons.video_off,
                    color: widget.iconColor ?? widget.errorColor,
                  ),
            label: value ? RtkStrings.videoOn : RtkStrings.videoOff,
            disabled: !isCameraGranted,
            onTap: () {
              _onVideoToggle();
              widget.onVideoToggle?.call();
            },
          ),
        );
      } else {
        return Center(
          child: RtkButtons.icon(
            value
                ? const Icon(DyteIcons.video_on)
                : Icon(
                    DyteIcons.video_off,
                    color: widget.errorColor,
                  ),
            designToken: widget.designTokens,
            iconSize: widget.iconSize,
            isDisabled: !isCameraGranted,
            onPressed: () {
              _onVideoToggle();
              widget.onVideoToggle?.call();
            },
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    widget.meeting.removeSelfEventListener(_selfVideoNotifier!);
    _selfVideoNotifier!.dispose();
    _selfVideoNotifier = null;
    super.dispose();
  }
}

class SelfVideoNotifier extends ValueNotifier<MediaToggleState>
    implements RtkSelfEventListener {
  final RealtimekitClient meeting;
  SelfVideoNotifier(this.meeting)
      : super(meeting.localUser.videoEnabled
            ? MediaToggleState.on
            : MediaToggleState.off);

  void startVideoToggle() {
    // fix: No idea how it worked!
    Future.microtask(() => value = MediaToggleState.inProgress);
  }

  @override
  void onVideoUpdate(bool videoEnabled) {
    value = videoEnabled ? MediaToggleState.on : MediaToggleState.off;
  }

  @override
  void onAudioUpdate(bool audioEnabled) {}

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
  void onUpdate(RtkSelfParticipant participant) {}

  @override
  void onScreenShareUpdate(bool isEnabled) {}

  @override
  void onPinned() {}

  @override
  void onUnpinned() {}
}
