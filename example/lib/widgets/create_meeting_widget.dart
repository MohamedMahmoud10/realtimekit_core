import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:example/widgets/rtk_text_field.dart';
import 'package:example/network/rtk_meeting_notifier.dart';

class CreateMeetingWidget extends ConsumerWidget {
  const CreateMeetingWidget({
    super.key,
    required this.meetingTitleController,
    required this.nameController,
  });

  final TextEditingController meetingTitleController;
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final rtkMeetingNotifier = ref.watch(rtkMeetingProvider.notifier);
    return Column(
      children: [
        Text("Create Meeting", style: theme.textTheme.displaySmall),
        const SizedBox(height: 8),
        RtkTextField(
          controller: meetingTitleController,
          hintText: 'Meeting Title',
        ),
        RtkTextField(hintText: 'Name', controller: nameController),
        ElevatedButton(
          onPressed: () {
            final meetingTitle = meetingTitleController.text.trim();
            final participantName = nameController.text.trim();
            if (participantName.isEmpty) return;
            rtkMeetingNotifier.createMeetingAndAddParticipant(
              meetingTitle,
              participantName,
            );
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(const Color(0xFFF17F1F)),
          ),
          child: const Text('Start', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
