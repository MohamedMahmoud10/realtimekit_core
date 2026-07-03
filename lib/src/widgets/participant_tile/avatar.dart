import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/core/rtk_uikit_component.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget with UiKitElement {
  final double? height;
  final double? width;
  final TextStyle? textStyle;
  const Avatar({
    required this.participant,
    this.height,
    this.width,
    this.textStyle,
    super.key,
  });

  final RtkMeetingParticipant participant;
  String _getInitialsFromName(String name) {
    String trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return 'NN';
    }
    if (trimmedName.length < 2) {
      return trimmedName.toUpperCase();
    }
    List<String> subNames = trimmedName.split(' ');
    return subNames.length >= 2
        ? '${subNames.first[0]}${subNames.last[0]}'.toUpperCase()
        : subNames.first.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double size = constraints.biggest.shortestSide * 0.45;
        return Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Center(
            child: participant.picture != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: Image.network(
                      participant.picture!,
                      height: size,
                      width: size,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, error, stackTrace) => Text(
                        _getInitialsFromName(participant.name),
                        style: AppTheme(globalDesignToken.colorToken)
                            .theme
                            .textTheme
                            .displayLarge
                            ?.copyWith(
                              fontSize: size / 2.5,
                            ),
                      ),
                      errorBuilder: (context, error, stackTrace) => Text(
                        _getInitialsFromName(participant.name),
                        style: AppTheme(globalDesignToken.colorToken)
                            .theme
                            .textTheme
                            .displayLarge
                            ?.copyWith(
                              fontSize: size / 2.5,
                            ),
                      ),
                    ),
                  )
                : Text(
                    _getInitialsFromName(participant.name),
                    style: AppTheme(globalDesignToken.colorToken)
                        .theme
                        .textTheme
                        .displayLarge
                        ?.copyWith(
                          fontSize: size / 2.5,
                        ),
                  ),
          ),
        );
      },
    );
  }

  @override
  double get borderRadius => borderToken.getRadius(BorderSize.max);

  @override
  double get borderWidth => 0.0;

  @override
  Color get fillColor => globalDesignToken.colorToken.brandColor.shade500;

  @override
  Color get textColor => globalDesignToken.colorToken.textColor.shade1000;
}
