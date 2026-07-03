import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/src/data/models/notification.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/atoms/vh_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget getNotificationContentForSnackbar({
  required RtkNotification notification,
  required BuildContext context,
}) {
  return Row(
    children: [
      _getIconForNotification(notification.type),
      hspace1,
      Expanded(
        child: Text(
          notification.message,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTheme(globalDesignToken.colorToken)
              .theme
              .textTheme
              .bodyMedium!,
        ),
      ),
      const Spacer(),
      GestureDetector(
        onTap: ScaffoldMessenger.of(context).hideCurrentSnackBar,
        child: Icon(
          DyteIcons.dismiss,
          color: AppTheme(globalDesignToken.colorToken)
              .theme
              .colorScheme
              .onPrimary,
        ),
      )
    ],
  );
}

Widget getTextContentForSnackbar(
  String message,
  BuildContext context,
) {
  return Row(
    children: [
      hspace1,
      Expanded(
        child: Text(
          message,
          style: AppTheme(globalDesignToken.colorToken)
              .theme
              .textTheme
              .bodyMedium!,
        ),
      ),
      const Spacer(),
      GestureDetector(
        onTap: ScaffoldMessenger.of(context).hideCurrentSnackBar,
        child: Icon(
          DyteIcons.dismiss,
          color: AppTheme(globalDesignToken.colorToken)
              .theme
              .colorScheme
              .onPrimary,
        ),
      )
    ],
  );
}

void showSnackbarWidget(BuildContext context, Widget content) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // ignore: deprecated_member_use
        backgroundColor: backgroundColorSwatch.shade900.withOpacity(0.85),
        onVisible: () async => await HapticFeedback.mediumImpact(),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(borderToken.getRadius(BorderSize.two)),
        ),
        content: SizedBox(width: context.width * 0.8, child: content),
      ),
    );

Icon _getIconForNotification(NotificationType type) {
  return {
    NotificationType.chat:
        Icon(DyteIcons.chat, color: textColorSwatch.shade1000),
    NotificationType.poll:
        Icon(DyteIcons.poll, color: textColorSwatch.shade1000),
    NotificationType.participant:
        Icon(DyteIcons.people, color: textColorSwatch.shade1000),
    NotificationType.plugin:
        Icon(DyteIcons.rocket, color: textColorSwatch.shade1000),
  }[type]!;
}
