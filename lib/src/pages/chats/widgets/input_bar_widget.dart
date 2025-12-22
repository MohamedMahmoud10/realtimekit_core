import 'package:dyte_icons/dyte_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/pages/chats/widgets/attachments_sheet_widget.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_icon_button.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text_field.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';

class InputBarWidget extends ConsumerStatefulWidget {
  const InputBarWidget({super.key});

  @override
  ConsumerState<InputBarWidget> createState() => _InputBarWidgetState();
}

class _InputBarWidgetState extends ConsumerState<InputBarWidget> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    final canSendText = rtkMeeting.permissions.chat.canSendText;
    final canSendFiles = rtkMeeting.permissions.chat.canSendFiles;

    if (!canSendText && !canSendFiles) return const SizedBox.shrink();

    return Container(
      width: context.width,
      padding: const EdgeInsets.all(10),
      color: theme.colorScheme.primaryContainer,
      child: Row(children: [
        if (canSendFiles) ...[
          RtkIconButton(
            backgroundColor: theme.colorScheme.secondaryContainer,
            icon: Icon(
              DyteIcons.add,
              color: theme.colorScheme.onSecondary,
            ),
            onPressed: () async => await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => const AttachmentsSheetWidget(),
            ),
          ),
        ],
        if (canSendText) ...[
          Expanded(
            child: RtkTextField(
              height: null,
              width: null,
              fillColor: theme.colorScheme.primaryContainer,
              controller: _messageController,
              hintText: '${RtkStrings.message}...',
              hintStyle: theme.textTheme.titleMedium,
              border: InputBorder.none,
              maxLines: null,
            ),
          ),
          RtkIconButton(
            backgroundColor: theme.colorScheme.primary,
            icon: Icon(
              DyteIcons.send,
              color: theme.colorScheme.onSecondary,
            ),
            onPressed: () async {
              final text = _messageController.text;
              if (text.trim().isEmpty) {
                ref
                    .read(notificationProvider.notifier)
                    .showCustomNotification('Message cannot be empty');
                return;
              }
              await ref
                  .read(chatActionNotifierProvider.notifier)
                  .sendText(text);
              _messageController.clear();
            },
          )
        ]
      ]),
    );
  }
}
