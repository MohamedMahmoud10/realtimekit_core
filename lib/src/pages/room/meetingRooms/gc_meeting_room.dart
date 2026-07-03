import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/data/states/notification_state.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:realtimekit_ui/src/pages/room/grid/active_particpants_widget.dart';
import 'package:realtimekit_ui/src/pages/room/grid/rtk_page_view_widget.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_app_bar.dart';
import 'package:realtimekit_ui/src/widgets/molecules/control_bar/rtk_control_bars.dart';
import 'package:realtimekit_ui/src/widgets/molecules/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const appbarHeight = 56.0;

class RtkGCMeetingRoom extends ConsumerWidget {
  const RtkGCMeetingRoom({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(notificationProvider, (previous, next) {
      if (next is OnNewNotificationReceived) {
        showSnackbarWidget(
          context,
          getNotificationContentForSnackbar(
              notification: next.notification, context: context),
        );
      }
    });

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: RtkAppBars.gc(),
        body: SafeArea(
          child: ref.watch(tabNotifierProvider).isEmpty ||
                  rtkMeeting.meta.meetingType == RtkMeetingType.livestream
              ? const ActiveParticipantsWidget()
              : const RtkPageViewWidget(),
        ),
        bottomNavigationBar: RtkControlBar.gc(),
      ),
    );
  }
}
