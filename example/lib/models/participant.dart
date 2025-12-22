// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

class CreateParticipantRequest {
  final String displayName;
  final String clientSpecificId;
  final String presetName;
  final String meetingId;
  CreateParticipantRequest({
    required this.displayName,
    required this.clientSpecificId,
    required this.presetName,
    required this.meetingId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'displayName': displayName,
      'clientSpecificId': clientSpecificId,
      'presetName': presetName,
      'meetingId': meetingId,
    };
  }

  String toJson() => json.encode(toMap());

  factory CreateParticipantRequest.fromName(String name, String meetingId) {
    return CreateParticipantRequest(
      displayName: name,
      clientSpecificId: Random().nextInt(10000).toString(),
      presetName: "group_call_host",
      meetingId: meetingId,
    );
  }
}

class CreateParticipantResponse {
  final bool success;
  final Participant data;

  CreateParticipantResponse({
    required this.success,
    required this.data,
  });

  factory CreateParticipantResponse.fromJson(String str) =>
      CreateParticipantResponse.fromMap(json.decode(str));

  factory CreateParticipantResponse.fromMap(Map<String, dynamic> json) =>
      CreateParticipantResponse(
        success: json["success"],
        data: Participant.fromMap(json["data"]),
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "success": success,
        "data": data.toMap(),
      };
}

class Participant {
  final String id;
  final String name;
  final String customParticipantId;
  final String presetId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String token;

  Participant({
    required this.id,
    required this.name,
    required this.customParticipantId,
    required this.presetId,
    required this.createdAt,
    required this.updatedAt,
    required this.token,
  });

  factory Participant.fromJson(String str) =>
      Participant.fromMap(json.decode(str));

  factory Participant.fromMap(Map<String, dynamic> json) => Participant(
        id: json["id"],
        name: json["name"],
        customParticipantId: json["custom_participant_id"],
        presetId: json["preset_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        token: json["token"],
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "custom_participant_id": customParticipantId,
        "preset_id": presetId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "token": token,
      };
}
