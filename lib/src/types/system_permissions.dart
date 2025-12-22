import 'dart:convert';

import 'package:realtimekit_core_platform_interface/src/utils/int_to_bool_convertor.dart';

class SystemPermissions {
  final bool isCameraPermissionGranted;
  final bool isMicrophonePermissionGranted;
  SystemPermissions({
    required this.isCameraPermissionGranted,
    required this.isMicrophonePermissionGranted,
  });

  SystemPermissions copyWith({
    bool? isCameraPermissionGranted,
    bool? isMicrophonePermissionGranted,
  }) {
    return SystemPermissions(
      isCameraPermissionGranted:
          isCameraPermissionGranted ?? this.isCameraPermissionGranted,
      isMicrophonePermissionGranted:
          isMicrophonePermissionGranted ?? this.isMicrophonePermissionGranted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isCameraPermissionGranted': isCameraPermissionGranted,
      'isMicrophonePermissionGranted': isMicrophonePermissionGranted,
    };
  }

  factory SystemPermissions.fromMap(Map<String, dynamic> map) {
    return SystemPermissions(
      isCameraPermissionGranted: decodeBool(map['isCameraPermissionGranted']),
      isMicrophonePermissionGranted:
          decodeBool(map['isMicrophonePermissionGranted']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SystemPermissions.fromJson(String source) =>
      SystemPermissions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SystemPermissions(isCameraPermissionGranted: $isCameraPermissionGranted, isMicrophonePermissionGranted: $isMicrophonePermissionGranted)';

  @override
  bool operator ==(covariant SystemPermissions other) {
    if (identical(this, other)) return true;

    return other.isCameraPermissionGranted == isCameraPermissionGranted &&
        other.isMicrophonePermissionGranted == isMicrophonePermissionGranted;
  }

  @override
  int get hashCode =>
      isCameraPermissionGranted.hashCode ^
      isMicrophonePermissionGranted.hashCode;
}
