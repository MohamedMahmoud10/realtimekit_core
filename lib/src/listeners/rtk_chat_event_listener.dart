import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';

abstract class RtkChatEventListener extends RtkListener {
  /// On chat updates
  /// Triggered when there is a update in chat messages available in this room.
  /// [messages] list of all messages in this room. This also contains messages exchanged before this peer joined in this room
  void onChatUpdates(List<ChatMessage> messages) {}

  /// On new chat message
  /// Triggered when there is a new chat messages exchanged in this room.
  void onNewChatMessage(ChatMessage message) {}
}

class RtkChatController extends RtkChatEventListener {
  RtkChatController._();
  static final RtkChatController instance = RtkChatController._();
  final List<ChatMessage> _chatMessages = [];

  List<ChatMessage> get chats => _chatMessages;

  @override
  void onChatUpdates(List<ChatMessage> messages) {
    _chatMessages.clear();
    _chatMessages.addAll(messages);
  }

  void dispose() {
    _chatMessages.clear();
  }
}
