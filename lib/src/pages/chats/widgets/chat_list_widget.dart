import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:realtimekit_ui/src/pages/chats/widgets/empty_chat_widget.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_file_message_layout.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_image_message_layout.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text_message_layout.dart';

class ChatListWidget extends ConsumerStatefulWidget {
  const ChatListWidget({super.key});

  @override
  ConsumerState<ChatListWidget> createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends ConsumerState<ChatListWidget> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(unreadChatNotifier, (prev, next) {
      final len = ref.read(chatListNotifier).length;
      ref.read(unreadChatNotifier.notifier).readAllMessages(len);
    });

    ref.listen<List<ChatMessage>>(chatListNotifier, (prev, next) async {
      // Skip auto-scroll on initial load to avoid opening animation.
      if (prev == null) return;
      if (!_scrollController.hasClients) return;
      final position = _scrollController.position;
      final atBottom = position.pixels >= position.maxScrollExtent - 48.0;
      if (atBottom) {
        await Future<void>.delayed(const Duration(milliseconds: 16));
        if (mounted && _scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      }
    });

    final messages = ref.watch(chatListNotifier);

    if (messages.isEmpty) {
      return const EmptyChatWidget();
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final key = ValueKey(_messageKey(message, index));
        switch (message.type) {
          case MessageType.text:
            return KeyedSubtree(
              key: key,
              child: RtkTextMessageWidget(textMessage: message as TextMessage),
            );
          case MessageType.image:
            return KeyedSubtree(
              key: key,
              child: RtkImageMessageLayout(
                imageMessage: message as ImageMessage,
              ),
            );
          case MessageType.file:
            return KeyedSubtree(
              key: key,
              child: RtkFileMessageLayout(
                fileMessage: message as FileMessage,
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  String _messageKey(ChatMessage m, int index) {
    return '${m.type}_$index';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
