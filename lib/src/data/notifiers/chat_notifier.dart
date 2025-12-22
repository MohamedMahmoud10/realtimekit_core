import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/di/di.dart';

import '../../../realtimekit_ui.dart';

class ChatListNotifier extends Notifier<List<ChatMessage>>
    implements RtkChatEventListener {
  @override
  List<ChatMessage> build() {
    return rtkMeeting.chat.messages;
  }

  @override
  void onChatUpdates(List<ChatMessage> messages) {
    state = messages;
  }

  @override
  void onNewChatMessage(ChatMessage message) {}
}

class UnreadChatNotifier extends Notifier<int> implements RtkChatEventListener {
  int _unread = 0;
  int _read = 0;

  void readAllMessages(int messagesLength) {
    _read = messagesLength;
    _unread = messagesLength;
    state = _unread - _read;
  }

  @override
  void onChatUpdates(List<ChatMessage> messages) {
    _unread = messages.length;
    state = _unread - _read;
  }

  @override
  int build() {
    _read = 0;
    _unread = rtkMeeting.chat.messages.length;
    return _unread - _read;
  }

  @override
  void onNewChatMessage(ChatMessage message) {}
}
