// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:realtimekit_core_platform_interface/src/utils/int_to_bool_convertor.dart';

class ChatMessage {
  ChatMessage({
    required this.displayName,
    required this.type,
    required this.read,
    required this.userId,
    this.pluginId,
    required this.time,
  });

  final String displayName;
  final MessageType type;
  final bool read;
  final String userId;
  final String? pluginId;
  final String time;

  static TextMessage textMessage({
    required String displayName,
    required bool read,
    String? pluginId,
    required String message,
    required String time,
    required String userid,
  }) {
    return TextMessage(
      pluginId: pluginId,
      time: time,
      userId: userid,
      message: message,
      displayName: displayName,
      read: read,
      type: MessageType.text,
    );
  }

  static ImageMessage imageMessage({
    required String userId,
    required String displayName,
    required bool read,
    String? pluginId,
    required String link,
    required String time,
  }) {
    return ImageMessage(
      pluginId: pluginId,
      time: time,
      userId: userId,
      link: link,
      displayName: displayName,
      read: read,
      type: MessageType.image,
    );
  }

  static FileMessage fileMessage({
    required String displayName,
    required bool read,
    String? pluginId,
    required String time,
    required String userId,
    required String name,
    required String link,
    required int size,
  }) {
    return FileMessage(
      name: name,
      link: link,
      size: size,
      pluginId: pluginId,
      time: time,
      userId: userId,
      displayName: displayName,
      read: read,
      type: MessageType.file,
    );
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    final type = _decodeType(map["type"]);
    switch (type) {
      case MessageType.text:
        return TextMessage(
          message: map["message"],
          userId: map["user"],
          pluginId: map["pluginId"],
          time: map["time"],
          displayName: map["displayName"],
          read: decodeBool(map["read"]),
          type: type,
        );
      case MessageType.image:
        return ImageMessage(
          pluginId: map["pluginId"],
          time: map["time"],
          userId: map["user"],
          link: map["link"],
          displayName: map["displayName"],
          read: decodeBool(map["read"]),
          type: type,
        );
      case MessageType.file:
        return FileMessage(
          name: map["name"],
          link: map["link"],
          size: map["size"],
          pluginId: map["pluginId"],
          time: map["time"],
          userId: map["user"],
          displayName: map["displayName"],
          read: decodeBool(map["read"]),
          type: type,
        );
    }
  }

  static MessageType _decodeType(String type) {
    if (type == "TEXT") {
      return MessageType.text;
    } else if (type == "IMAGE") {
      return MessageType.image;
    } else {
      return MessageType.file;
    }
  }

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatMessage(displayName: $displayName, type: $type, read: $read, userId: $userId, pluginId: $pluginId, time: $time)';
  }

  @override
  bool operator ==(covariant ChatMessage other) {
    if (identical(this, other)) return true;

    return other.displayName == displayName &&
        other.type == type &&
        other.read == read &&
        other.userId == userId &&
        other.pluginId == pluginId &&
        other.time == time;
  }

  @override
  int get hashCode {
    return displayName.hashCode ^
        type.hashCode ^
        read.hashCode ^
        userId.hashCode ^
        pluginId.hashCode ^
        time.hashCode;
  }
}

/// [MessageType]
enum MessageType { text, image, file }

class TextMessage extends ChatMessage {
  final String message;
  TextMessage({
    required this.message,
    required super.displayName,
    required super.read,
    required super.type,
    required super.pluginId,
    required super.time,
    required super.userId,
  });
}

class ImageMessage extends ChatMessage {
  final String link;
  ImageMessage({
    required this.link,
    required super.displayName,
    required super.read,
    required super.type,
    required super.pluginId,
    required super.time,
    required super.userId,
  });
}

class FileMessage extends ChatMessage {
  final String name;
  final String link;
  final int size;
  FileMessage({
    required this.name,
    required this.link,
    required this.size,
    required super.displayName,
    required super.read,
    required super.type,
    required super.pluginId,
    required super.time,
    required super.userId,
  });
}
