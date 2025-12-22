import 'dart:convert';

class AudioDevice {
  final String id;
  final AudioDeviceType type;
  AudioDevice({
    required this.id,
    required this.type,
  });

  AudioDevice copyWith({
    String? id,
    AudioDeviceType? type,
  }) {
    return AudioDevice(
      id: id ?? this.id,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type.toMap(),
    };
  }

  factory AudioDevice.fromMap(Map<String, dynamic> map) {
    return AudioDevice(
      id: map['id'] as String,
      type: AudioDeviceType.fromMap(map['type'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AudioDevice.fromJson(String? source) {
    if (source != null) {
      return AudioDevice.fromMap(json.decode(source) as Map<String, dynamic>);
    } else {
      return AudioDevice(id: "", type: AudioDeviceType.unknown);
    }
  }

  @override
  String toString() => 'AudioDevice(id: $id, type: $type)';

  @override
  bool operator ==(covariant AudioDevice other) {
    if (identical(this, other)) return true;

    return other.id == id && other.type == type;
  }

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}

enum AudioDeviceType {
  wired('WIRED_HEADSET', 'Headset'),
  speaker('SPEAKER_PHONE', 'Speaker'),
  bluetooth('BLUETOOTH', 'Bluetooth'),
  earpiece('EARPIECE', 'Earpiece'),
  unknown('NONE', 'Unknown');

  const AudioDeviceType(this.deviceType, this.displayName);

  final String deviceType;
  final String displayName;

  factory AudioDeviceType.fromMap(Map<String, dynamic> map) {
    final String deviceType = map['deviceType'];
    switch (deviceType) {
      case 'WIRED_HEADSET':
        return wired;
      case 'SPEAKER_PHONE':
        return speaker;
      case 'BLUETOOTH':
        return bluetooth;
      case 'EARPIECE':
        return earpiece;
      default:
        return unknown;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'deviceType': deviceType,
      'displayName': displayName,
    };
  }
}
