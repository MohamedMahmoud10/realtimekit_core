// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:realtimekit_core_platform_interface/src/enums/rtk_active_tab_type.dart';
import 'package:realtimekit_core_platform_interface/src/types/design_token/rtk_design_token.dart';
import 'package:realtimekit_core_platform_interface/src/types/rtk_active_tab.dart';

enum RtkMeetingType {
  groupCall("GROUP_CALL"),
  webinar("WEBINAR"),
  livestream("LIVESTREAM");

  final String name;
  const RtkMeetingType(this.name);

  static RtkMeetingType fromName(String name) {
    switch (name.toUpperCase()) {
      case "GROUP_CALL":
        return RtkMeetingType.groupCall;
      case "WEBINAR":
        return RtkMeetingType.webinar;
      case "LIVESTREAM":
        return RtkMeetingType.livestream;
      default:
        return RtkMeetingType.groupCall;
    }
  }

  static String fromType(RtkMeetingType type) {
    switch (type) {
      case RtkMeetingType.groupCall:
        return "GROUP_CALL";
      case RtkMeetingType.webinar:
        return "WEBINAR";
      case RtkMeetingType.livestream:
        return "LIVESTREAM";
      default:
        return "GROUP_CALL";
    }
  }
}

class RtkMeta {
  final String meetingId;
  final String meetingTitle;
  final String meetingStartedTimeStamp;
  final RtkMeetingType meetingType;
  ActiveTab? activeTab;
  final RtkDesignTokens designToken;
  RtkMeta({
    required this.meetingId,
    required this.meetingTitle,
    required this.meetingStartedTimeStamp,
    required this.meetingType,
    this.activeTab,
    required this.designToken,
  });

  syncTab(String id, RtkActiveTabType type) {}

  RtkMeta copyWith({
    String? meetingId,
    String? meetingTitle,
    String? meetingStartedTimeStamp,
    RtkMeetingType? meetingType,
    ActiveTab? activeTab,
    RtkDesignTokens? designToken,
  }) {
    return RtkMeta(
      meetingId: meetingId ?? this.meetingId,
      meetingTitle: meetingTitle ?? this.meetingTitle,
      meetingStartedTimeStamp:
          meetingStartedTimeStamp ?? this.meetingStartedTimeStamp,
      meetingType: meetingType ?? this.meetingType,
      activeTab: activeTab ?? this.activeTab,
      designToken: designToken ?? this.designToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'meetingId': meetingId,
      'roomTitle': meetingTitle,
      'meetingStartedTimeStamp': meetingStartedTimeStamp,
      'meetingType': RtkMeetingType.fromType(meetingType),
      'activeTab': activeTab.toString(),
      'designToken': "design-token",
    };
  }

  factory RtkMeta.fromMap(
      Map<String, dynamic> map, Map<String, dynamic> activeTab) {
    return RtkMeta(
      meetingId: map['meetingId'] as String,
      meetingTitle: map['meetingTitle'] as String,
      meetingStartedTimeStamp: map['meetingStartedTimeStamp'] ?? "",
      meetingType: RtkMeetingType.fromName(map['meetingType'] as String),
      activeTab: ActiveTab.fromMap(activeTab),
      designToken: RtkDesignTokens(),
    );
  }

  String toJson() => json.encode(toMap());

  factory RtkMeta.fromJson(String source, String activeTab) => RtkMeta.fromMap(
        json.decode(source) as Map<String, dynamic>,
        json.encode(activeTab) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'RtkMeta(meetingId: $meetingId, roomTitle: $meetingTitle, meetingStartedTimeStamp: $meetingStartedTimeStamp, meetingType: $meetingType, activeTab: ${activeTab.toString()})';
  }

  @override
  bool operator ==(covariant RtkMeta other) {
    if (identical(this, other)) return true;

    return other.meetingId == meetingId &&
        other.meetingTitle == meetingTitle &&
        other.meetingStartedTimeStamp == meetingStartedTimeStamp &&
        other.meetingType == meetingType;
  }

  @override
  int get hashCode {
    return meetingId.hashCode ^
        meetingTitle.hashCode ^
        meetingStartedTimeStamp.hashCode ^
        meetingType.hashCode;
  }
}
