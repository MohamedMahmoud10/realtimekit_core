import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/pages/room/grid/rtk_page_view_widget.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/molecules/control_bar/rtk_control_bars.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../realtimekit_ui.dart';
import '../../../di/riverpod_di.dart';
import '../../../widgets/atoms/rtk_app_bar.dart';
import '../../../widgets/atoms/rtk_text.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text_button.dart';
import '../grid/active_particpants_widget.dart';

class RtkWebinarMeetingRoom extends ConsumerWidget {
  final AudioDevice? selectedAudioDevice;
  final VideoDevice? selectedVideoDevice;

  const RtkWebinarMeetingRoom(
      this.selectedAudioDevice, this.selectedVideoDevice,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to stage request updates
    ref.listen(stageStatusNotifier, (previous, next) {
      if (next == StageStatus.acceptedToJoinStage &&
          previous != StageStatus.acceptedToJoinStage) {
        void showJoinStageAlertDialog(BuildContext ctx) {
          final theme = AppTheme(globalDesignToken.colorToken).theme;
          // set up the button
          Widget joinButton = RtkTextButton(
            label: "Join",
            labelStyle: theme.textTheme.bodyMedium!
                .copyWith(color: theme.colorScheme.onSecondary),
            variant: Variant.danger,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              rtkMeeting.stage.join();
            },
          );

          Widget cancelButton = RtkTextButton(
            label: "Cancel",
            labelStyle: theme.textTheme.bodyMedium!
                .copyWith(color: theme.colorScheme.onSecondary),
            variant: Variant.secondary,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              // NOTE: leave() is used to reset StageStatus.acceptedToJoinStage back to StageStatus.offStage
              rtkMeeting.stage.leave();
            },
          );
          // set up the AlertDialog
          AlertDialog alert = AlertDialog(
            backgroundColor: theme.colorScheme.primaryContainer,
            title: RtkText(
              "Join Stage",
              rtkTextStyle: theme.textTheme.headlineMedium!
                  .copyWith(color: theme.colorScheme.onSecondary),
            ),
            actions: [
              cancelButton,
              joinButton,
            ],
            actionsAlignment: MainAxisAlignment.center,
          );

          // show the dialog
          showDialog(
            context: ctx,
            barrierDismissible: false,
            builder: (BuildContext ctx) {
              return alert;
            },
          );
        }

        return showJoinStageAlertDialog(context);
      }
    });

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: RtkAppBars.webinar(),
        body: SafeArea(
          child: ref.watch(tabNotifierProvider).isEmpty
              ? const ActiveParticipantsWidget()
              : const RtkPageViewWidget(),
        ),
        bottomNavigationBar: RtkControlBar.webinar(),
      ),
    );
  }
}
