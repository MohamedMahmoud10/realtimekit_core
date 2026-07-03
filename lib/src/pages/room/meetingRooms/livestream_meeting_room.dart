import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/pages/room/grid/active_particpants_widget.dart';
import 'package:realtimekit_ui/src/pages/room/grid/rtk_page_view_widget.dart';

import 'package:realtimekit_ui/src/strings.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text_button.dart';
import 'package:realtimekit_ui/src/widgets/molecules/control_bar/rtk_control_bars.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../realtimekit_ui.dart';
import '../../../di/riverpod_di.dart';
import '../../../widgets/atoms/rtk_app_bar.dart';
import '../../../widgets/atoms/rtk_text.dart';

class RtkLivestreamMeetingRoom extends ConsumerWidget {
  final AudioDevice? selectedAudioDevice;
  final VideoDevice? selectedVideoDevice;

  const RtkLivestreamMeetingRoom(
      this.selectedAudioDevice, this.selectedVideoDevice,
      {super.key});

  Widget _buildCancelButton(ThemeData theme, BuildContext context) {
    return RtkTextButton(
      label: "Cancel",
      labelStyle: theme.textTheme.bodyMedium!
          .copyWith(color: theme.colorScheme.onSecondary),
      variant: Variant.secondary,
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        rtkMeeting.stage.cancelRequestAccess();
      },
    );
  }

  Widget _buildJoinButton(ThemeData theme, BuildContext context) {
    return RtkTextButton(
      label: "Join",
      labelStyle: theme.textTheme.bodyMedium!
          .copyWith(color: theme.colorScheme.onSecondary),
      variant: Variant.danger,
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        rtkMeeting.stage.join();
      },
    );
  }

  void showJoinStageAlertDialog(BuildContext context) {
    final ThemeData theme = AppTheme(globalDesignToken.colorToken).theme;
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: theme.colorScheme.primaryContainer,
      title: RtkText(
        "Join Stage",
        rtkTextStyle: theme.textTheme.headlineMedium!
            .copyWith(color: theme.colorScheme.onSecondary),
      ),
      actions: [
        _buildJoinButton(theme, context),
        _buildCancelButton(theme, context),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isOnStage = ref.watch(
        stageStatusNotifier.select((status) => status == StageStatus.onStage));

    ref.listen(stageStatusNotifier, (previous, next) {
      if (next == StageStatus.acceptedToJoinStage &&
          previous != StageStatus.acceptedToJoinStage) {
        return showJoinStageAlertDialog(context);
      }
    });

    if (!isOnStage) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: RtkAppBars.lvs(),
          body: const SafeArea(child: ShowLivestreamWidget()),
          bottomNavigationBar: RtkControlBar.livestream(),
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: RtkAppBars.lvs(),
          body: SafeArea(
            child: ref.watch(tabNotifierProvider).isEmpty
                ? const ActiveParticipantsWidget()
                : const RtkPageViewWidget(),
          ),
          bottomNavigationBar: RtkControlBar.livestream(),
        ),
      );
    }
  }
}

class ShowLivestreamWidget extends ConsumerWidget {
  const ShowLivestreamWidget({super.key});

  Widget _getLvsWidget(ThemeData theme, LivestreamState lvsState) {
    switch (lvsState) {
      case LivestreamState.starting:
        return Center(
          child: RtkText(
            "Starting Livestream...",
            rtkTextStyle: theme.textTheme.bodyMedium,
          ),
        );
      case LivestreamState.started:
        return Center(
            child: LivestreamView(rtkMeeting.livestream.data.playbackUrl!));
      case LivestreamState.ending:
        return Center(
          child: RtkText(
            "Ending Livestream...",
            rtkTextStyle: theme.textTheme.bodyMedium,
          ),
        );
      case LivestreamState.ended:
        return Center(
          child: RtkText(
            "${RtkStrings.waitingToGoLive}...",
            rtkTextStyle: theme.textTheme.bodyMedium,
          ),
        );

      case LivestreamState.errored:
        return Center(
          child: RtkText(
            "Error while streaming livestream.",
            rtkTextStyle: theme.textTheme.bodyMedium,
          ),
        );
      case LivestreamState.none:
        return Center(
          child: RtkText(
            "${RtkStrings.waitingToGoLive}...",
            rtkTextStyle: theme.textTheme.bodyMedium,
          ),
        );
      default:
        return Center(
          child: RtkText(
            "${RtkStrings.waitingToGoLive}...",
            rtkTextStyle: theme.textTheme.bodyMedium,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lvsState = ref.watch(
        lvsStateNotifier.select((value) => rtkMeeting.livestream.data.state));
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return _getLvsWidget(theme, lvsState);
  }
}
