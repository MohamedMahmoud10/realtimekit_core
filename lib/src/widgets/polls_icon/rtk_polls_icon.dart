import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/routes/route_names.dart';
import 'package:realtimekit_ui/src/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RtkPollsIconWidget extends ConsumerWidget {
  const RtkPollsIconWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        RtkRouter.of(context).push(
          const RtkPollsScreen(),
          pageName: RouteNames.polls,
        );
      },
      icon: Icon(
        DyteIcons.poll,
        // TODO: use AppTheme
        color: globalDesignToken.colorToken.textColor.shade1000,
      ),
    );
  }
}
