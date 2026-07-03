import 'package:realtimekit_core/realtimekit_core.dart';

abstract class ChatStates {}

class ChatStateInitial extends ChatStates {}

class OnChatUpdates extends ChatStates {
  final List<ChatMessage> messages;
  OnChatUpdates(this.messages);
}

class OnNewChatMessage extends ChatStates {
  final ChatMessage message;
  OnNewChatMessage(this.message);
}
