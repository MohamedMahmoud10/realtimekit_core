import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/atoms/participant_count.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_icon_button.dart';
import 'package:realtimekit_ui/src/widgets/atoms/vh_space.dart';
import 'package:flutter/material.dart';
import 'package:realtimekit_ui/src/widgets/meeting_title/rtk_meeting_title.dart';

import '../../di/di.dart';
import '../../pages/livestream/live_host_count_widget.dart';
import '../../pages/livestream/live_indicator_widget.dart';
import '../../pages/livestream/live_viewer_count_widget.dart';
import '../../pages/room/widgets/meeting_timer_widget.dart';
import '../../pages/room/widgets/recorder_widget.dart';
import '../../pages/room/widgets/switch_camera_widget.dart';

class RtkAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Icon? leadingIcon;
  final VoidCallback? onPressed;
  final Widget? title;
  final bool centerTitle;
  final bool hasLeading;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double titleSpacing;

  // Cache theme to avoid repeated creation
  static final _theme = AppTheme(globalDesignToken.colorToken).theme;

  const RtkAppBar({
    super.key,
    this.leadingIcon,
    this.onPressed,
    this.backgroundColor,
    this.actions,
    this.hasLeading = true,
    this.centerTitle = true,
    this.bottom,
    this.titleSpacing = 10,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? _theme.colorScheme.primaryContainer,
      centerTitle: centerTitle,
      scrolledUnderElevation: 0.0,
      automaticallyImplyLeading: hasLeading,
      titleSpacing: titleSpacing,
      leading: hasLeading
          ? RtkIconButton(
              backgroundColor: _theme.colorScheme.primaryContainer,
              icon: leadingIcon ?? const Icon(DyteIcons.back),
              onPressed: onPressed ?? () {},
            )
          : null,
      title: title,
      bottom: bottom,
      actions: actions ?? [],
    );
  }

  Widget _buildAppBarTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: hspace1.width!,
      ),
      child: Column(
        children: [
          Row(
            children: [
              RtkMeetingTitle(meeting: rtkMeeting),
            ],
          ),
          _buildAppBarBottom(context),
        ],
      ),
    );
  }

  PreferredSize _buildAppBarBottom(BuildContext context,
      {bool showMeetingDuration = true}) {
    return PreferredSize(
      preferredSize: Size.zero,
      child: Row(children: [
        const ParticipantCount(),
        hspace1,
        if (showMeetingDuration) ...[
          Text(
            "•",
            style: _theme.textTheme.bodyLarge!
                .copyWith(color: textColorSwatch.shade700),
          ),
          hspace1,
          const RtkMeetingTimerWidget()
        ],
      ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(52);
}

class _GCAppBar extends RtkAppBar {
  const _GCAppBar();

  Widget _buildAppBar(BuildContext context) {
    return RtkAppBar(
      backgroundColor: RtkAppBar._theme.colorScheme.surface,
      hasLeading: false,
      centerTitle: false,
      title: _buildAppBarTitle(context),
      actions: const [
        RecorderWidget(),
        SwitchCameraWidget(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: _buildAppBar(context));
  }
}

class _WebinarAppBar extends RtkAppBar {
  const _WebinarAppBar();

  Widget _buildAppBar(BuildContext context) {
    return RtkAppBar(
      backgroundColor: RtkAppBar._theme.colorScheme.surface,
      hasLeading: false,
      title: _buildAppBarTitle(context),
      actions: const [
        RecorderWidget(),
        SwitchCameraWidget(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: _buildAppBar(context));
  }
}

class _LivestreamAppBar extends RtkAppBar {
  const _LivestreamAppBar();

  Widget _buildAppBar(BuildContext context) {
    return RtkAppBar(
      backgroundColor: RtkAppBar._theme.colorScheme.surface,
      hasLeading: false,
      title: _buildAppBarTitle(context),
      actions: const [
        RecorderWidget(),
        LiveIndicatorWidget(),
        LiveHostCountWidget(),
        LiveViewerCountWidget(),
        SwitchCameraWidget(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: _buildAppBar(context));
  }
}

class RtkAppBars {
  RtkAppBars._();

  static RtkAppBar gc() {
    return const _GCAppBar();
  }

  static RtkAppBar webinar() {
    return const _WebinarAppBar();
  }

  static RtkAppBar lvs() {
    return const _LivestreamAppBar();
  }
}
