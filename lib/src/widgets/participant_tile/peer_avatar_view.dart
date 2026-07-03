import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/widgets/participant_tile/avatar.dart';
import 'package:flutter/material.dart';

class PeerAvatarView extends StatelessWidget {
  const PeerAvatarView(
    this.participant, {
    super.key,
    required this.backgroundColor,
    this.borderRadius = double.maxFinite,
  });
  final RtkMeetingParticipant participant;
  final double borderRadius;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Avatar(participant: participant),
      ),
    );
  }
}
