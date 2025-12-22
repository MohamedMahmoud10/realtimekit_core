// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:realtimekit_core_platform_interface/src/enums/rtk_active_tab_type.dart';

class ActiveTab {
  String id;
  RtkActiveTabType type;
  String userId;
  ActiveTab({
    required this.id,
    required this.type,
    required this.userId,
  });

  ActiveTab copyWith({
    String? id,
    String? userId,
  }) {
    return ActiveTab(
      id: id ?? this.id,
      type: type,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type.name,
      'userId': userId,
    };
  }

  factory ActiveTab.fromMap(Map<String, dynamic> map) {
    return ActiveTab(
      id: map['id'] as String,
      type: RtkActiveTabType.fromName(map['type'] as String),
      userId: map['userId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActiveTab.fromJson(String source) =>
      ActiveTab.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ActiveTab(id: $id, type: ${type.name}, userId: $userId)';

  @override
  bool operator ==(covariant ActiveTab other) {
    if (identical(this, other)) return true;

    return other.id == id && other.userId == userId;
  }

  @override
  int get hashCode => id.hashCode ^ userId.hashCode;
}
