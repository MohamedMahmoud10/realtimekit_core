// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:realtimekit_core_platform_interface/src/utils/int_to_bool_convertor.dart';

class RtkMeetingInfo {
  final String authToken;
  final bool enableAudio;
  final bool enableVideo;
  final String baseDomain;
  final String displayName;
  final Widget? customAppBarWidget;

  RtkMeetingInfo({
    required this.authToken,
    this.baseDomain = 'dyte.io',
    this.displayName = 'Hello from Flutter',
    this.enableAudio = true,
    this.enableVideo = true,
    this.customAppBarWidget,
  });

  RtkMeetingInfo copyWith({
    String? authToken,
    bool? enableAudio,
    bool? enableVideo,
    String? baseDomain,
    Widget? customAppBarWidget,
  }) {
    return RtkMeetingInfo(
      authToken: authToken ?? this.authToken,
      baseDomain: baseDomain ?? this.baseDomain,
      enableAudio: enableAudio ?? this.enableAudio,
      enableVideo: enableVideo ?? this.enableVideo,
      customAppBarWidget: customAppBarWidget ?? this.customAppBarWidget,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'authToken': authToken,
      'baseDomain': baseDomain,
      'enableAudio': enableAudio,
      'enableVideo': enableVideo,
    };
  }

  @override
  factory RtkMeetingInfo.fromMap(Map<String, dynamic> map) {
    return RtkMeetingInfo(
      authToken: map['authToken'] as String,
      baseDomain: map['baseDomain'] as String,
      enableAudio: decodeBool(map['enableAudio']),
      enableVideo: decodeBool(map['enableVideo']),
    );
  }

  @override
  factory RtkMeetingInfo.fromJson(String source) =>
      RtkMeetingInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'RtkMeetingInfo(authToken: $authToken, baseDomain: $baseDomain, enableAudio: $enableAudio, enableVideo: $enableVideo)';

  @override
  bool operator ==(covariant RtkMeetingInfo other) {
    if (identical(this, other)) return true;

    return other.authToken == authToken &&
        other.baseDomain == baseDomain &&
        other.enableAudio == enableAudio &&
        other.enableVideo == enableVideo;
  }

  @override
  int get hashCode =>
      authToken.hashCode ^
      baseDomain.hashCode ^
      enableAudio.hashCode ^
      enableVideo.hashCode;
}
