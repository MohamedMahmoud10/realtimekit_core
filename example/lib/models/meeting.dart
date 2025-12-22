import 'dart:convert';

class CreateMeetingReponse {
  final bool success;
  final Meeting data;

  CreateMeetingReponse({
    required this.success,
    required this.data,
  });

  factory CreateMeetingReponse.fromJson(String str) =>
      CreateMeetingReponse.fromMap(json.decode(str));

  factory CreateMeetingReponse.fromMap(Map<String, dynamic> json) =>
      CreateMeetingReponse(
        success: json["success"],
        data: Meeting.fromMap(json["data"]),
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "success": success,
        "data": data.toMap(),
      };
}

class CreateMeetingRequest {
  final String? title;
  final String preferredRegion;
  final bool recordOnStart;
  final bool liveStreamOnStart;

  CreateMeetingRequest({
    required this.title,
    required this.preferredRegion,
    required this.recordOnStart,
    required this.liveStreamOnStart,
  });

  factory CreateMeetingRequest.fromMeetingTitle(
    String title, {
    String? region,
    bool? recordOnStart,
    bool? liveStreamOnStart,
  }) {
    return CreateMeetingRequest(
      title: title.isNotEmpty ? title : null,
      preferredRegion: region ?? "ap-south-1",
      recordOnStart: recordOnStart ?? false,
      liveStreamOnStart: liveStreamOnStart ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        if (title != null) "title": title,
        "preferred_region": preferredRegion,
        "record_on_start": recordOnStart,
        "live_stream_on_start": liveStreamOnStart,
      };
}

class Meeting {
  final String id;
  final bool recordOnStart;
  final bool liveStreamOnStart;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Meeting({
    required this.id,
    required this.recordOnStart,
    required this.liveStreamOnStart,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Meeting.fromJson(String str) => Meeting.fromMap(json.decode(str));

  factory Meeting.fromMap(Map<String, dynamic> json) => Meeting(
        id: json["id"],
        recordOnStart: json["record_on_start"],
        liveStreamOnStart: json["live_stream_on_start"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "id": id,
        "record_on_start": recordOnStart,
        "live_stream_on_start": liveStreamOnStart,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
