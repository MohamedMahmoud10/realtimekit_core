import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/data/notifiers/participants_notifier.dart';
import 'package:realtimekit_ui/src/data/notifiers/pin_unpin_notifier.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:realtimekit_ui/src/pages/participants/widgets/host_options.dart';
import 'package:realtimekit_ui/src/pages/participants/widgets/video_icon_widget.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_app_bar.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_icon_button.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_list_tile.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text_button.dart';
import 'package:realtimekit_ui/src/widgets/atoms/vh_space.dart';
import 'package:realtimekit_ui/src/widgets/participant_tile/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/notifiers/audio_notifier.dart';
import '../../data/notifiers/video_notifier.dart';
import '../../routes/router.dart';
import '../../utils/generate_key.dart';
import '../../widgets/atoms/rtk_button.dart';

class RtkParticipantsPage extends ConsumerStatefulWidget {
  const RtkParticipantsPage({super.key});

  @override
  ConsumerState<RtkParticipantsPage> createState() =>
      _RtkParticipantsPageState();
}

bool _isWebinarParticipantOnStage(RtkMeetingParticipant participant) {
  return rtkMeeting.meta.meetingType == RtkMeetingType.webinar &&
      participant.stageStatus != StageStatus.onStage;
}

class _RtkParticipantsPageState extends ConsumerState<RtkParticipantsPage> {
  final isMeetingGroupCall =
      rtkMeeting.meta.meetingType == RtkMeetingType.groupCall;
  List<Widget> _addPresetHostActions(
      SelfPermissions permissions, RtkMeetingParticipant participant) {
    List<Widget> hostActions = [];
    if (permissions.host.canPinParticipant &&
        participant.id != rtkMeeting.localUser.id &&
        (!_isWebinarParticipantOnStage(participant) || isMeetingGroupCall)) {
      hostActions.add(PinningToggler(participant: participant));
    }

    if (permissions.host.canMuteVideo &&
        (!_isWebinarParticipantOnStage(participant) || isMeetingGroupCall)) {
      hostActions.add(DisableVideoControllerWidget(participant: participant));
    }

    if (permissions.host.canMuteAudio &&
        (!_isWebinarParticipantOnStage(participant) || isMeetingGroupCall)) {
      hostActions.add(DisableAudioControllerWidget(participant: participant));
    }

    if (permissions.host.canKickParticipant &&
        participant.id != rtkMeeting.localUser.id) {
      hostActions.add(KickParticipantController(participant: participant));
      if (rtkMeeting.meta.meetingType != RtkMeetingType.groupCall) {
        hostActions.add(StageParticipantController(
            participant: participant as RtkRemoteParticipant));
      }
    }
    // only insert name tile when user has some host actions else return empty list
    if (hostActions.isNotEmpty) {
      final nameTile = RtkListTile(
        title: RtkText(
          participant.name,
          textAlign: TextAlign.center,
        ),
      );
      hostActions.insert(0, nameTile);
    }

    return hostActions;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;

    return Scaffold(
      appBar: RtkAppBar(
        title: RtkText(RtkStrings.participants),
        leadingIcon: const Icon(DyteIcons.dismiss),
        onPressed: () => RtkRouter.of(context).pop(),
      ),
      body: SafeArea(
        child: SizedBox(
          height: context.height,
          child: Consumer(
            builder: (context, ref, child) {
              final participantsAsync = ref.watch(participantsProvider);
              return participantsAsync.when(
                data: (state) {
                  return ListView(
                    children: [
                      ..._buildWaitlistedSection(context, state, theme),
                      ..._buildStageRequestsSection(context, state, theme),
                      if (state.isGroupCall)
                        ..._buildMainParticipantsSection(context, state, theme),
                      if (state.isWebinar)
                        ..._buildPresenterSection(context, state, theme),
                      if (state.isWebinar)
                        ..._buildViewersSection(context, state, theme),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              );
            },
          ),
        ),
      ),
    );
  }

  bool isHostPermissionAvailable(SelfPermissions permissions) =>
      permissions.host.canMuteVideo ||
      permissions.host.canMuteAudio ||
      permissions.host.canPinParticipant ||
      permissions.host.canKickParticipant;

  List<Widget> _buildWaitlistedSection(
      BuildContext context, ParticipantsState state, ThemeData theme) {
    if (!state.hasWaitlistedParticipants) return [];

    return [
      Container(
        margin: EdgeInsets.only(
          top: context.adjust(20),
          bottom: context.adjust(12),
        ),
        child: RtkText(
          "Waitlisted (${state.waitlisted.length})",
          textAlign: TextAlign.center,
        ),
      ),
      ...state.waitlisted.map(
        (waitlistedParticipant) => RtkListTile(
          title: RtkText(waitlistedParticipant.name),
          tileColor: theme.colorScheme.surface,
          leading: Avatar(
            participant: waitlistedParticipant,
            height: 32,
            width: 32,
            textStyle: theme.textTheme.bodyMedium,
          ),
          trailing: SizedBox(
            width: context.width * 0.4,
            child: Row(
              children: [
                const Spacer(),
                RtkIconButton(
                  icon: const Icon(DyteIcons.dismiss, color: Colors.red),
                  onPressed: () => rtkMeeting.participants
                      .rejectWaitlistedParticipant(waitlistedParticipant),
                ),
                SizedBox(width: context.adjust(8)),
                RtkIconButton(
                  icon: Icon(DyteIcons.checkmark, color: Colors.green[800]),
                  onPressed: () => rtkMeeting.participants
                      .acceptWaitlistedParticipant(waitlistedParticipant),
                ),
              ],
            ),
          ),
        ),
      ),
      if (state.waitlisted.length > 1)
        RtkTextButton(
          onPressed: () {
            for (final participant in state.waitlisted) {
              rtkMeeting.participants.acceptWaitlistedParticipant(participant);
            }
          },
          label: "Accept all",
        ),
    ];
  }

  List<Widget> _buildStageRequestsSection(
      BuildContext context, ParticipantsState state, ThemeData theme) {
    if (!state.hasStageRequests) return [];

    return [
      Container(
        margin: EdgeInsets.only(
          top: context.adjust(20),
          bottom: context.adjust(12),
        ),
        child: RtkText(
          "Stage Requests (${state.stageRequests.length})",
          textAlign: TextAlign.center,
        ),
      ),
      ...state.stageRequests.map(
        (requestParticipant) => RtkListTile(
          title: RtkText(requestParticipant.name),
          tileColor: theme.colorScheme.surface,
          trailing: SizedBox(
            width: context.width * 0.4,
            child: Row(
              children: [
                const Spacer(),
                RtkIconButton(
                  icon: const Icon(DyteIcons.dismiss, color: Colors.red),
                  onPressed: () =>
                      rtkMeeting.stage.denyAccess([requestParticipant.userId]),
                ),
                SizedBox(width: context.adjust(8)),
                RtkIconButton(
                  icon: Icon(DyteIcons.checkmark, color: Colors.green[800]),
                  onPressed: () =>
                      rtkMeeting.stage.grantAccess([requestParticipant.userId]),
                ),
              ],
            ),
          ),
        ),
      ),
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RtkButton(
            onPressed: () {
              final accessRequests = state.stageRequests;
              final userIds = accessRequests.map((e) => e.userId).toList();
              rtkMeeting.stage.grantAccess(userIds);
            },
            backgroundColor: theme.colorScheme.tertiary,
            child: const RtkText("Accept all"),
          ),
          RtkButton(
            onPressed: () {
              final accessRequests = state.stageRequests;
              final userIds = accessRequests.map((e) => e.userId).toList();
              rtkMeeting.stage.denyAccess(userIds);
            },
            backgroundColor: theme.colorScheme.error,
            child: const RtkText("Deny all"),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildMainParticipantsSection(
      BuildContext context, ParticipantsState state, ThemeData theme) {
    return [
      Container(
        margin: EdgeInsets.only(
          top: context.adjust(20),
          bottom: context.adjust(12),
        ),
        child: RtkText(
          "${RtkStrings.participants} (${state.totalParticipantCount})",
          textAlign: TextAlign.center,
        ),
      ),
      _buildParticipantTile(context, state.localUser, theme, isLocalUser: true),
      ...state.mainParticipants.map(
        (participant) => _buildParticipantTile(context, participant, theme),
      ),
    ];
  }

  List<Widget> _buildPresenterSection(
      BuildContext context, ParticipantsState state, ThemeData theme) {
    return [
      Container(
        margin: EdgeInsets.only(
          top: context.adjust(20),
          bottom: context.adjust(12),
        ),
        child: RtkText(
          "Presenters (${state.presenters.length})",
          textAlign: TextAlign.center,
        ),
      ),
      ...state.presenters.map(
        (participant) => _buildParticipantTile(context, participant, theme),
      ),
    ];
  }

  List<Widget> _buildViewersSection(
      BuildContext context, ParticipantsState state, ThemeData theme) {
    if (!state.isWebinar || state.viewers.isEmpty) return [];

    return [
      Container(
        margin: EdgeInsets.only(
          top: context.adjust(20),
          bottom: context.adjust(12),
        ),
        child: RtkText(
          "Viewers (${state.viewers.length})",
          textAlign: TextAlign.center,
        ),
      ),
      ...state.viewers.map((viewer) {
        final hostActions =
            _addPresetHostActions(rtkMeeting.permissions, viewer);
        return RtkListTile(
          title: RtkText(
            state.localUser.id == viewer.id
                ? "${viewer.name} (${RtkStrings.you})"
                : viewer.name,
          ),
          tileColor: theme.colorScheme.surface,
          leading: Avatar(
            participant: viewer,
            height: 32,
            width: 32,
            textStyle: theme.textTheme.bodyMedium,
          ),
          trailing: SizedBox(
            width: context.width * 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (hostActions.isNotEmpty)
                  RtkIconButton(
                    icon: const Icon(DyteIcons.more_vertical),
                    backgroundColor: theme.colorScheme.surface,
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      builder: (ctx) => HostOptionsWidget(
                        participant: viewer,
                        hostActions: hostActions,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    ];
  }

  Widget _buildParticipantTile(
      BuildContext context, RtkMeetingParticipant participant, ThemeData theme,
      {bool isLocalUser = false}) {
    final displayName = isLocalUser
        ? "${participant.name} (${RtkStrings.you})"
        : participant.name;

    return RtkListTile(
      title: RtkText(displayName),
      tileColor: theme.colorScheme.surface,
      leading: Avatar(
        participant: participant,
        height: 32,
        width: 32,
        textStyle: theme.textTheme.bodyMedium,
      ),
      trailing: SizedBox(
        width: context.width * 0.4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RtkAudioIndicatorIconWidget(participant: participant),
            hspace3,
            VideoIcon(participant: participant),
            if (_addPresetHostActions(rtkMeeting.permissions, participant)
                .isNotEmpty)
              RtkIconButton(
                icon: const Icon(DyteIcons.more_vertical),
                backgroundColor: theme.colorScheme.surface,
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (ctx) => HostOptionsWidget(
                    participant: participant,
                    hostActions: _addPresetHostActions(
                        rtkMeeting.permissions, participant),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DisableVideoControllerWidget extends ConsumerStatefulWidget {
  final RtkMeetingParticipant participant;
  const DisableVideoControllerWidget({
    super.key,
    required this.participant,
  });

  @override
  ConsumerState<DisableVideoControllerWidget> createState() =>
      _DisableVideoControllerWidgetState();
}

class _DisableVideoControllerWidgetState
    extends ConsumerState<DisableVideoControllerWidget> {
  late final VideoNotifier videoNotifier;
  @override
  void initState() {
    videoNotifier = VideoNotifier(widget.participant);
    rtkMeeting.addParticipantsEventListener(videoNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: videoNotifier,
      builder: (context, bool videoEnabled, child) => RtkListTile(
        leading: Icon(videoEnabled ? DyteIcons.video_on : DyteIcons.video_off),
        key: generateVideoKeyForParticipant(widget.participant,
            pageName: 'VideoIcon'),
        title: RtkText(videoEnabled
            ? RtkStrings.turnOffVideo
            : RtkStrings.videoAlreadyOff),
        iconColor: videoEnabled
            ? AppTheme(globalDesignToken.colorToken).theme.colorScheme.onPrimary
            : AppTheme(globalDesignToken.colorToken).theme.colorScheme.error,
        onTap: () {
          if (videoEnabled) {
            if (widget.participant.id != rtkMeeting.localUser.id) {
              (widget.participant as RtkRemoteParticipant).disableVideo();
            } else {
              rtkMeeting.localUser.disableVideo();
            }
            RtkRouter.of(context).pop();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    rtkMeeting.removeParticipantsEventListener(videoNotifier);
    super.dispose();
  }
}

class DisableAudioControllerWidget extends ConsumerStatefulWidget {
  final RtkMeetingParticipant participant;
  const DisableAudioControllerWidget({
    super.key,
    required this.participant,
  });

  @override
  ConsumerState<DisableAudioControllerWidget> createState() =>
      _DisableAudioControllerWidgetState();
}

class _DisableAudioControllerWidgetState
    extends ConsumerState<DisableAudioControllerWidget> {
  late final AudioNotifier audioNotifier;

  @override
  void initState() {
    audioNotifier = AudioNotifier(widget.participant);
    rtkMeeting.addParticipantsEventListener(audioNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return ValueListenableBuilder(
      valueListenable: audioNotifier,
      builder: (context, bool audioEnabled, child) => RtkListTile(
        key: generateAudioKeyForParticipant(widget.participant,
            pageName: 'AudioIcon'),
        leading: Icon(audioEnabled ? DyteIcons.mic_on : DyteIcons.mic_off),
        title: RtkText(audioEnabled ? RtkStrings.mute : RtkStrings.unmute),
        iconColor: audioEnabled
            ? theme.colorScheme.onSecondary
            : theme.colorScheme.error,
        onTap: () {
          if (audioEnabled) {
            if (widget.participant.id != rtkMeeting.localUser.id) {
              (widget.participant as RtkRemoteParticipant).disableAudio();
            } else {
              rtkMeeting.localUser.disableAudio();
            }
            RtkRouter.of(context).pop();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    rtkMeeting.removeParticipantsEventListener(audioNotifier);
    super.dispose();
  }
}

class PinningToggler extends StatefulWidget {
  final RtkMeetingParticipant participant;
  const PinningToggler({
    super.key,
    required this.participant,
  });

  @override
  State<PinningToggler> createState() => _PinningTogglerState();
}

class _PinningTogglerState extends State<PinningToggler> {
  bool checkPinned(RtkMeetingParticipant pinnedParticipant) =>
      pinnedParticipant.id == widget.participant.id;

  late PinNotifier? _pinNotifier;

  @override
  void initState() {
    _pinNotifier = PinNotifier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _pinNotifier!,
      builder: (context, pinnedParticipant, child) {
        final isPinned =
            pinnedParticipant != null ? checkPinned(pinnedParticipant) : false;
        return RtkListTile(
          title: RtkText(isPinned ? RtkStrings.unpin : RtkStrings.pin),
          leading: isPinned
              ? const Icon(DyteIcons.pin_off)
              : const Icon(DyteIcons.pin),
          onTap: () {
            isPinned ? widget.participant.unpin() : widget.participant.pin();
            RtkRouter.of(context).pop();
          },
        );
      },
    );
  }

  @override
  void dispose() {
    if (_pinNotifier != null) {
      _pinNotifier = null;
    }
    super.dispose();
  }
}

class KickParticipantController extends ConsumerWidget {
  final RtkMeetingParticipant participant;
  const KickParticipantController({
    super.key,
    required this.participant,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RtkListTile(
      leading: const Icon(Icons.person_off_outlined),
      iconColor: AppTheme(globalDesignToken.colorToken).theme.colorScheme.error,
      title: RtkText(RtkStrings.kick),
      onTap: () {
        (participant as RtkRemoteParticipant).kick();
        RtkRouter.of(context).pop();
      },
    );
  }
}

class StageParticipantController extends ConsumerWidget {
  final RtkRemoteParticipant participant;
  const StageParticipantController({
    super.key,
    required this.participant,
  });

  String _getStageText() {
    if (participant.stageStatus == StageStatus.onStage) {
      return RtkStrings.removeFromStage;
    } else {
      return RtkStrings.inviteToStage;
    }
  }

  Icon _getStageIcon() {
    if (participant.stageStatus == StageStatus.onStage) {
      return const Icon(DyteIcons.leave_stage);
    } else {
      return const Icon(DyteIcons.join_stage);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RtkListTile(
      leading: _getStageIcon(),
      iconColor: AppTheme(globalDesignToken.colorToken).theme.colorScheme.error,
      title: RtkText(_getStageText()),
      onTap: () {
        if (participant.stageStatus != StageStatus.onStage) {
          rtkMeeting.stage.grantAccess([participant.userId]);
        } else {
          rtkMeeting.stage.kick([participant.userId]);
        }
        RtkRouter.of(context).pop();
      },
    );
  }
}
