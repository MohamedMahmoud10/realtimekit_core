import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/src/data/models/notification.dart';
import 'package:realtimekit_ui/src/data/notifiers/participants_notifier.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:realtimekit_ui/src/pages/room/grid/rtk_regular_tile_grid_delegate.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:realtimekit_ui/src/utils/generate_key.dart';
import 'package:realtimekit_ui/src/widgets/atoms/vh_space.dart';
import 'package:realtimekit_ui/src/widgets/molecules/snackbar.dart';
import 'package:realtimekit_ui/src/widgets/participant_tile/rtk_participant_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/states/waitlisted_participant_states.dart';

class ActiveParticipantsWidget extends ConsumerStatefulWidget {
  const ActiveParticipantsWidget({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _ActiveParticipantsGridState();
}

class _ActiveParticipantsGridState
    extends ConsumerState<ActiveParticipantsWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    ref.listen(
      waitingRoomNotifier,
      (previous, next) {
        switch (next.runtimeType) {
          case WaitlistedParticipantAccepted:
            final participant =
                (next as WaitlistedParticipantAccepted).participant;
            getNotificationContentForSnackbar(
              context: context,
              notification: RtkNotification(
                  '${participant.name}\'s has joined the meeting.',
                  NotificationType.participant),
            );
            break;
          case WaitlistedParticipantRejected:
            final participant =
                (next as WaitlistedParticipantRejected).participant;
            getNotificationContentForSnackbar(
              context: context,
              notification: RtkNotification(
                  '${participant.name}\'s request has been rejected.',
                  NotificationType.participant),
            );
            break;
          case WaitlistedParticipantJoined:
            final participant =
                (next as WaitlistedParticipantJoined).participant;
            getNotificationContentForSnackbar(
              context: context,
              notification: RtkNotification(
                  '${participant.name}\'s is in the waiting room.',
                  NotificationType.participant),
            );
            break;
          case WaitlistedParticipantClosed:
            final participant =
                (next as WaitlistedParticipantClosed).participant;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${participant.name} has closed the meeting.'),
            ));
            break;
          default:
            break;
        }
      },
    );

    final participantsAsync = ref.watch(participantsProvider);

    return participantsAsync.when(
      data: (state) {
        final List<RtkMeetingParticipant> participants =
            _getActiveParticipants(state);
        return Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                participants.isEmpty
                    ? const Text("There is no one on stage.")
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: context.height * 0.6,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: RtkRegularTileGridDelegate(
                              activeParticipantCount: participants.length,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              context: context,
                            ),
                            itemCount: participants.length,
                            itemBuilder: (context, index) {
                              final participant = participants[index];
                              return participants.length == 1
                                  ? AspectRatio(
                                      aspectRatio: 4 / 3,
                                      child: RtkParticipantTile(
                                        participant,
                                        key: generateKeyForParticipant(
                                          participant,
                                        ),
                                      ),
                                    )
                                  : RtkParticipantTile(
                                      participant,
                                      key: generateKeyForParticipant(
                                        participant,
                                      ),
                                    );
                            },
                          ),
                        ),
                      ),
                vspace1,
                RtkPageToggler(data: _getParticipantsForToggler(state)),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  List<RtkMeetingParticipant> _getActiveParticipants(ParticipantsState state) {
    List<RtkMeetingParticipant> participants;

    if (state.isGroupCall) {
      participants = List<RtkMeetingParticipant>.from(state.mainParticipants);
      if (!participants.any((p) => p.id == state.localUser.id)) {
        participants.add(state.localUser);
      }
    } else if (state.isWebinar) {
      participants = List<RtkMeetingParticipant>.from(state.presenters);
    } else {
      participants = List<RtkMeetingParticipant>.from(state.active);
      if (!participants.any((p) => p.id == state.localUser.id)) {
        participants.add(state.localUser);
      }
    }

    return participants;
  }

  List<RtkMeetingParticipant> _getParticipantsForToggler(
      ParticipantsState state) {
    if (state.isGroupCall) {
      return state.mainParticipants.cast<RtkMeetingParticipant>();
    } else if (state.isWebinar) {
      return state.presenters;
    } else {
      return state.active.cast<RtkMeetingParticipant>();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class RtkPageToggler extends ConsumerWidget {
  final List<RtkMeetingParticipant> data;
  const RtkPageToggler({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (rtkMeeting.meta.meetingType == RtkMeetingType.groupCall &&
        data.isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: ref.watch(gridNotifier).isPreviousPagePossible
                ? ref.read(gridNotifier.notifier).previousPage
                : null,
            icon: const Icon(
              DyteIcons.chevron_left,
            ),
          ),
          hspace1,
          IconButton(
            onPressed: ref.watch(gridNotifier).isNextPagePossible
                ? ref.read(gridNotifier.notifier).nextPage
                : null,
            icon: const Icon(
              DyteIcons.chevron_right,
            ),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
