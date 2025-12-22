import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:realtimekit_ui/src/tokens/size/app_size.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/atoms/vh_space.dart';
import 'package:realtimekit_ui/src/widgets/core/core.dart';
import 'package:realtimekit_ui/src/widgets/core/rtk_uikit_component.dart';
import 'package:flutter/material.dart';

class RtkLeaveMeetingDialog extends StatelessWidget implements UiKitElement {
  const RtkLeaveMeetingDialog({
    required this.meeting,
    this.designToken,
    super.key,
  });

  final RealtimekitClient meeting;

  final RtkDesignTokens? designToken;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return AlertDialog(
      elevation: 0,
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.all(16),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: fillColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              RtkStrings.leave,
              style: theme.textTheme.headlineLarge!.copyWith(
                fontSize: fontSize.s150,
                fontWeight: FontWeight.w600,
              ),
            ),
            vspace2,
            Text(
              RtkStrings.areYouSureYouWantToLeaveTheCall,
              style: theme.textTheme.bodySmall,
            ),
            vspaceHalf,
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: RtkButtons.solid(
                    label: RtkStrings.cancel,
                    height: AppSize.s10,
                    backgroundColor:
                        globalDesignToken.colorToken.backgroundColor.shade800,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ),
                hspace4,
                Expanded(
                  child: RtkButtons.solid(
                    label: RtkStrings.leave,
                    height: AppSize.s10,
                    backgroundColor: globalDesignToken.colorToken.danger,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      meeting.leaveRoom();
                    },
                  ),
                ),
              ],
            ),
            if (meeting.permissions.host.canKickParticipant) ...[
              vspaceHalf,
              RtkButtons.solid(
                label: RtkStrings.endMeetingForAll,
                height: AppSize.s10,
                backgroundColor: globalDesignToken.colorToken.danger,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  meeting.participants.kickAll();
                },
              ),
            ]
          ],
        ),
      ),
    );
  }

  @override
  double get borderRadius =>
      designToken?.borderToken.getRadius(BorderSize.zero) ??
      globalDesignToken.borderToken.getRadius(BorderSize.zero);

  @override
  double get borderWidth => 0.0;

  @override
  Color get fillColor =>
      designToken?.colorToken.backgroundColor.shade1000 ??
      globalDesignToken.colorToken.backgroundColor.shade1000;

  @override
  Color get textColor =>
      designToken?.colorToken.textColor.shade1000 ??
      globalDesignToken.colorToken.textColor.shade1000;
}
