import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/core/rtk_uikit_component.dart';
import 'package:flutter/material.dart';

class RtkMeetingTitle extends StatelessWidget with UiKitElement {
  RtkMeetingTitle({
    super.key,
    required this.meeting,
    RtkDesignTokens? individualDesignToken,
  }) : designToken = individualDesignToken ?? globalDesignToken;

  final RealtimekitClient meeting;
  final RtkDesignTokens designToken;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return Flexible(
      flex: 1,
      child: Text(
        meeting.meta.meetingTitle,
        style: theme.textTheme.bodyMedium!.copyWith(color: textColor),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  double get borderRadius => 0.0;

  @override
  double get borderWidth => 0.0;

  @override
  Color get fillColor => designToken.colorToken.brandColor.shade500;

  @override
  Color get textColor => designToken.colorToken.textColor.shade1000;
}
