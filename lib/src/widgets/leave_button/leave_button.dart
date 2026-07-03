import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:realtimekit_ui/src/tokens/size/app_size.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:realtimekit_ui/src/widgets/core/core.dart';
import 'package:realtimekit_ui/src/widgets/core/rtk_uikit_component.dart';
import 'package:realtimekit_ui/src/widgets/leave_button/leave_meeting.dart';
import 'package:flutter/material.dart';

class RtkLeaveButton extends StatefulWidget with UiKitElement {
  RtkLeaveButton({
    required this.meeting,
    final RtkDesignTokens? individualDesignToken,
    super.key,
    this.height,
    this.width,
  }) : designToken = individualDesignToken ?? globalDesignToken;

  final RtkDesignTokens designToken;
  final RealtimekitClient meeting;
  final double? height;
  final double? width;

  @override
  State<RtkLeaveButton> createState() => _RtkLeaveButtonState();

  @override
  double get borderRadius => designToken.borderToken.getRadius(BorderSize.one);

  @override
  double get borderWidth => 0.0;

  @override
  Color get fillColor => designToken.colorToken.danger;

  @override
  Color get textColor => designToken.colorToken.textColor.shade1000;
}

class _RtkLeaveButtonState extends State<RtkLeaveButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.adjust(AppSize.s12),
      width: context.adjust(AppSize.s12),
      decoration: BoxDecoration(
        color: widget.fillColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: RtkButtons.icon(
        const Icon(DyteIcons.call_end),
        onPressed: () {
          showDialog(
            builder: (context) {
              return RtkLeaveMeetingDialog(meeting: widget.meeting);
            },
            context: context,
          );
        },
      ),
    );
  }
}
