import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';

class RtkNameTag extends ConsumerStatefulWidget {
  final RtkMeetingParticipant participant;
  final double size;
  final double factor;
  final Color color;
  const RtkNameTag({
    super.key,
    required this.participant,
    required this.size,
    required this.color,
    this.factor = 7,
  });

  @override
  ConsumerState<RtkNameTag> createState() => _RtkNameTagState();
}

class _RtkNameTagState extends ConsumerState<RtkNameTag> {
  late String participantName;
  @override
  void initState() {
    participantName = widget.participant.name;

    if (widget.participant.id == rtkMeeting.localUser.id) {
      participantName += ' (${RtkStrings.you})';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    participantName = ref.watch(editNameProvider.select((name) =>
        widget.participant.id == rtkMeeting.localUser.id
            ? '$name(${RtkStrings.you})'
            : widget.participant.name));

    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return Container(
      constraints: BoxConstraints(maxWidth: widget.size),
      child: RtkText(
        participantName,
        rtkTextStyle: theme.textTheme.bodyMedium!.copyWith(
          fontSize: widget.size / widget.factor,
          color: widget.color,
        ),
      ),
    );
  }
}
