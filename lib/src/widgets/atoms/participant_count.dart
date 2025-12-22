import 'package:realtimekit_ui/src/data/states/participant_event_states.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParticipantCount extends ConsumerWidget {
  const ParticipantCount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int joinedParticipants = rtkMeeting.participants.joined.length;

    final theme = AppTheme(globalDesignToken.colorToken).theme;

    ref.listen<ParticipantEventStates>(
      participantEventNotifier,
      (previous, next) {
        if (next.runtimeType == OnUpdate) {
          joinedParticipants = ref.watch(
            participantEventNotifier.select((s) => s is OnUpdate
                ? s.participants.joined.length
                : rtkMeeting.participants.joined.length),
          );
        }
      },
    );

    // +1 for self
    final totalParticipants = joinedParticipants + 1;

    return Text(
      '$totalParticipants participants',
      style: theme.textTheme.bodyLarge,
    );
  }
}
