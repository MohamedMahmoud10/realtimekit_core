import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/src/data/notifiers/screenshare_notifier.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_bottom_nav_button.dart';
import 'package:realtimekit_ui/src/widgets/core/core.dart';

import '../../../realtimekit_ui.dart';
import '../../di/di.dart';
import '../core/rtk_uikit_component.dart';

class RtkScreenshareWidget extends ConsumerStatefulWidget with UsesStatusColor {
  final RtkDesignTokens designTokens;
  final bool showLabel;
  final double? iconSize;
  final Color? iconColor;
  final RealtimekitClient meeting;

  RtkScreenshareWidget({
    required this.meeting,
    super.key,
    this.showLabel = false,
    this.iconColor,
    this.iconSize,
    RtkDesignTokens? individualDesignToken,
  }) : designTokens = individualDesignToken ?? globalDesignToken;

  @override
  Color get errorColor => designTokens.colorToken.danger;

  @override
  Color get successColor => designTokens.colorToken.success;

  @override
  Color get warningColor => designTokens.colorToken.warning;

  @override
  ConsumerState<RtkScreenshareWidget> createState() =>
      _RtkScreenshareWidgetState();
}

class _RtkScreenshareWidgetState extends ConsumerState<RtkScreenshareWidget> {
  final screenshareLimitNotifier = ScreenshareLimitNotifier();
  @override
  void initState() {
    rtkMeeting.addDataUpdateEventListener(screenshareLimitNotifier);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    rtkMeeting.removeDataUpdateEventListener(screenshareLimitNotifier);
  }

  @override
  Widget build(BuildContext context) {
    final selfScreensharePresent = ref.watch(selfScreenshareProvider);
    if (rtkMeeting.permissions.media.screenshare == MediaPermission.allowed ||
        (rtkMeeting.permissions.media.screenshare ==
                MediaPermission.canRequest &&
            rtkMeeting.stage.status == StageStatus.onStage)) {
      return ValueListenableBuilder(
          valueListenable: screenshareLimitNotifier,
          builder: (context, isLimitReached, child) {
            final disabled = isLimitReached && !selfScreensharePresent;
            return widget.showLabel
                ? Center(
                    child: RtkBottomNavButton(
                      disabled: disabled,
                      icon: selfScreensharePresent
                          ? Icon(DyteIcons.share_screen_stop,
                              color: widget.iconColor ?? widget.errorColor)
                          : const Icon(
                              DyteIcons.share_screen_start,
                            ),
                      label: selfScreensharePresent
                          ? RtkStrings.stopSharing
                          : RtkStrings.screenShare,
                      onTap: () {
                        selfScreensharePresent
                            ? rtkMeeting.localUser.disableScreenShare()
                            : rtkMeeting.localUser.enableScreenShare();
                      },
                    ),
                  )
                : Center(
                    child: RtkButtons.icon(
                      selfScreensharePresent
                          ? Icon(DyteIcons.share_screen_stop,
                              color: widget.iconColor ?? widget.errorColor)
                          : const Icon(
                              DyteIcons.share_screen_start,
                            ),
                      designToken: widget.designTokens,
                      iconSize: widget.iconSize,
                      isDisabled: disabled,
                      onPressed: () {
                        selfScreensharePresent
                            ? rtkMeeting.localUser.disableScreenShare()
                            : rtkMeeting.localUser.enableScreenShare();
                      },
                    ),
                  );
          });
    } else {
      return const SizedBox.shrink();
    }
  }
}
