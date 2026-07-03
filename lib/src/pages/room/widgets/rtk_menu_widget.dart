import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:realtimekit_ui/src/pages/chats/chats_page.dart';
import 'package:realtimekit_ui/src/pages/participants/participants_page.dart';
import 'package:realtimekit_ui/src/routes/route_names.dart';
import 'package:realtimekit_ui/src/routes/router.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_list_tile.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';
import 'package:realtimekit_ui/src/widgets/atoms/vh_space.dart';
import 'package:realtimekit_ui/src/widgets/molecules/more_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/molecules/go_live_button_widget.dart';
import '../../polls/polls_screen.dart';
import '../../setup/settings_page.dart';

class RtkMenuWidget extends ConsumerWidget {
  final bool canLivestream;
  const RtkMenuWidget({
    super.key,
    this.canLivestream = false,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    final hostPermissions = rtkMeeting.permissions.host;

    final muteAllAudios = RtkListTile(
      leading: const Icon(DyteIcons.speaker_off),
      title: RtkText(
        RtkStrings.muteAll,
      ),
      onTap: () {
        RtkRouter.of(context).pop();
        rtkMeeting.participants.disableAllAudio();
      },
    );

    final List<Widget> options = [
      if (rtkMeeting.permissions.poll.canView)
        RtkListTile(
          leading: const Icon(
            DyteIcons.poll,
          ),
          title: RtkText(RtkStrings.polls),
          onTap: () {
            RtkRouter.of(context).pop();
            RtkRouter.of(context)
                .push(const RtkPollsScreen(), pageName: RouteNames.polls);
            ref.read(unreadPollsNotifier.notifier).markAllAsRead(
                  ref.read(pollsListNotifier).length,
                );
          },
          trailing: UnreadCountWidget(
            unreadNotitifers: [unreadPollsNotifier],
          ),
        ),
      if (rtkMeeting.permissions.chat.canSendText ||
          rtkMeeting.permissions.chat.canSendFiles)
        RtkListTile(
          leading: const Icon(DyteIcons.chat),
          title: RtkText(RtkStrings.chat),
          onTap: () {
            RtkRouter.of(context).pop();
            ref.read(unreadChatNotifier.notifier).readAllMessages(
                  ref.read(chatListNotifier).length,
                );
            RtkRouter.of(context).push(
              const ChatsPage(),
              pageName: RouteNames.chats,
            );
          },
          trailing: UnreadCountWidget(
            unreadNotitifers: [unreadChatNotifier],
          ),
        ),
      RtkListTile(
        leading: const Icon(DyteIcons.participants),
        title: RtkText(RtkStrings.participants),
        onTap: () {
          RtkRouter.of(context).pop();
          RtkRouter.of(context).push(
            const RtkParticipantsPage(),
            pageName: RouteNames.participants,
          );
        },
        trailing: UnreadCountWidget(
          unreadNotitifers: [
            unreadStageRequestCountNotifier,
            unreadWaitlistedCountNotifier
          ],
        ),
      ),
      if (hostPermissions.canTriggerRecording) const RecorderButton(),
      // TODO: @thisisamank restore plugin functionality after mobile-core release
      // if (rtkMobileClient.permissions.plugin.canLaunch ||
      //     rtkMobileClient.permissions.plugin.canClose)
      //   RtkListTile(
      //     leading: const Icon(
      //       DyteIcons.rocket,
      //     ),
      //     title: RtkText(RtkStrings.plugins),
      //     onTap: () {
      //       RtkRouter.of(context).pop();
      //       RtkRouter.of(context).push(
      //         const RtkPluginsScreen(),
      //       );
      //     },
      //   ),
      if (hostPermissions.canMuteAudio) muteAllAudios,
      if (canLivestream) const GoLiveButtonWidget(),
      RtkListTile(
        leading: const Icon(
          DyteIcons.settings,
        ),
        title: RtkText(RtkStrings.settings),
        onTap: () {
          RtkRouter.of(context).pop();
          RtkRouter.of(context).push(
            SetupSettingsPage(),
            pageName: RouteNames.settings,
          );
        },
      ),
    ];
    return Container(
      height: options.length * 60,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            borderToken.getRadius(BorderSize.two),
          ),
          topRight: Radius.circular(
            borderToken.getRadius(BorderSize.two),
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: hspace1.width!),
      child: ListView(
        children: options,
      ),
    );
  }
}

class RecorderButton extends ConsumerWidget {
  const RecorderButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(recordingNotifier) == RecordingState.recording
        ? RtkListTile(
            leading: const Icon(
              DyteIcons.stop_recording,
            ),
            title: RtkText(RtkStrings.stopRecording),
            onTap: () {
              rtkMeeting.recording.stop((err) {});
              RtkRouter.of(context).pop();
            },
          )
        : RtkListTile(
            leading: const Icon(
              DyteIcons.recording,
            ),
            title: RtkText(RtkStrings.startRecording),
            onTap: () {
              rtkMeeting.recording.start((err) {});
              RtkRouter.of(context).pop();
            },
          );
  }
}
