import 'package:realtimekit_core_platform_interface/src/listeners/rtk_chat_event_listener.dart';
import 'package:realtimekit_core_platform_interface/src/types/rtk_chat_message.dart';

import 'errors/rtk_error.dart';

abstract class RtkChat {
  List<ChatMessage> get messages => RtkChatController.instance.chats;
  void sendTextMessage(String message);

  void sendFileMessage(String path, OnResult onResult);

  void sendImageMessage(String path, OnResult onResult);

  void downloadAttachment(String url, {String fileName = ""});
}
