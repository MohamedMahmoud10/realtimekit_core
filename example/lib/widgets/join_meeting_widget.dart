import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:example/widgets/rtk_text_field.dart';
import 'package:example/network/rtk_meeting_notifier.dart';

class JoinMeetingWidget extends ConsumerWidget {
  const JoinMeetingWidget({
    super.key,
    required this.meetingCodeController,
    required this.nameController,
  });

  final TextEditingController meetingCodeController;
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final rtkMeetingNotifier = ref.watch(rtkMeetingProvider.notifier);
    return Column(
      children: [
        Text("Join Meeting", style: theme.textTheme.displaySmall),
        const SizedBox(height: 8),
        RtkTextField(
          controller: meetingCodeController,
          hintText: 'Meeting Code',
        ),
        RtkTextField(controller: nameController, hintText: 'Name'),
        ElevatedButton(
          onPressed: () {
            final meetingId = meetingCodeController.text.trim();
            final participantName = nameController.text.trim();
            if (meetingId.isEmpty || participantName.isEmpty) return;
            rtkMeetingNotifier.addParticipant(meetingId, participantName);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(const Color(0xFFF17F1F)),
          ),
          child: const Text('Join', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
