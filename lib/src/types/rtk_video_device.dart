// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VideoDevice {
  final String id;
  final VideoDeviceType type;
  final CameraType cameraType;

  VideoDevice({
    required this.id,
    required this.type,
    required this.cameraType,
  });

  VideoDevice copyWith({
    String? id,
    VideoDeviceType? type,
    CameraType? cameraType,
  }) {
    return VideoDevice(
      id: id ?? this.id,
      type: type ?? this.type,
      cameraType: cameraType ?? this.cameraType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type.toMap(),
      'cameraType': cameraType.toMap(),
    };
  }

  factory VideoDevice.fromMap(Map<String, dynamic> map) {
    return VideoDevice(
      id: map['id'] as String,
      type: VideoDeviceType.fromMap(map['type'] as Map<String, dynamic>),
      cameraType: CameraType.fromMap(map['cameraType'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoDevice.fromJson(String source) =>
      VideoDevice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    final deviceTypeName = type.displayName;
    final camTypeName = cameraType.displayName;
    if (camTypeName.isNotEmpty) {
      return '$deviceTypeName ($camTypeName)';
    } else {
      return deviceTypeName;
    }
  }

  @override
  bool operator ==(covariant VideoDevice other) {
    if (identical(this, other)) return true;

    return other.id == id && other.type == type;
  }

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}

enum VideoDeviceType {
  front('Front camera'),
  rear('Rear camera'),
  ext('External');

  const VideoDeviceType(this.displayName);
  final String displayName;

  factory VideoDeviceType.fromMap(Map<String, dynamic> map) {
    final String displayName = map['displayName'];
    switch (displayName) {
      case 'Front camera':
        return front;
      case 'Rear camera':
        return rear;
      default:
        return ext;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
    };
  }
}

enum CameraType {
  ultraWide('Ultra wide angle'),
  wide('Wide angle'),
  telephoto('Telephoto'),
  normal('');

  const CameraType(this.displayName);
  final String displayName;

  factory CameraType.fromMap(Map<String, dynamic> map) {
    final String displayName = map['displayName'];
    switch (displayName) {
      case 'Ultra wide angle':
        return ultraWide;
      case 'Wide angle':
        return wide;
      case 'Telephoto':
        return telephoto;
      default:
        return normal;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
    };
  }
}
