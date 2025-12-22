import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_bottom_nav_button.dart';

class RtkStageRequestButton extends ConsumerWidget {
  const RtkStageRequestButton({super.key});

  Icon _getCurrentStageIcon(StageStatus stageStatus) {
    switch (stageStatus) {
      case StageStatus.offStage:
        return const Icon(DyteIcons.join_stage);
      case StageStatus.requestedToJoinStage:
        return const Icon(DyteIcons.dismiss);
      case StageStatus.acceptedToJoinStage:
        return const Icon(DyteIcons.join_stage);
      case StageStatus.onStage:
        return const Icon(DyteIcons.leave_stage);
    }
  }

  String _getCurrentStageLabel(StageStatus stageStatus) {
    switch (stageStatus) {
      case StageStatus.offStage:
        return "Join Stage";
      case StageStatus.requestedToJoinStage:
        return "Requested";
      case StageStatus.acceptedToJoinStage:
        return "Join Stage";
      case StageStatus.onStage:
        return "Leave Stage";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stagePermission = ref.read(stagePermissionNotifier);
    final stageStatus = ref.watch(stageStatusNotifier);
    final isRequestAllowed =
        ref.read(stagePermissionNotifier) != MediaPermission.notAllowed;
    return isRequestAllowed
        ? RtkBottomNavButton(
            icon: _getCurrentStageIcon(stageStatus),
            label: _getCurrentStageLabel(stageStatus),
            onTap: () {
              if (stagePermission == MediaPermission.canRequest) {
                switch (stageStatus) {
                  case StageStatus.offStage:
                    rtkMeeting.stage.requestAccess();
                    break;
                  case StageStatus.onStage:
                    rtkMeeting.stage.leave();
                    break;
                  default:
                    rtkMeeting.stage.cancelRequestAccess();
                    break;
                }
              }
              if (stagePermission == MediaPermission.allowed) {
                switch (stageStatus) {
                  case StageStatus.offStage:
                    rtkMeeting.stage.join();
                    break;
                  case StageStatus.onStage:
                    rtkMeeting.stage.leave();
                    break;
                  default:
                    break;
                }
              }
            })
        : const SizedBox.shrink();
  }
}
