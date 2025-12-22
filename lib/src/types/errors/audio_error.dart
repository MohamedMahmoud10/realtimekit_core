import 'dart:convert';

import 'package:realtimekit_core_platform_interface/src/types/errors/rtk_error.dart';

abstract class AudioError implements RtkError {
  @override
  final String message;

  const AudioError(this.message);
}

class AudioErrorPresetPermissionDenied extends AudioError {
  const AudioErrorPresetPermissionDenied()
      : super(AudioErrorUtils.errMsgPresetPermissionDenied);
}

class AudioErrorDevicePermissionDenied extends AudioError {
  const AudioErrorDevicePermissionDenied()
      : super(AudioErrorUtils.errMsgDevicePermissionDenied);
}

class AudioErrorAudioOperationFailed extends AudioError {
  const AudioErrorAudioOperationFailed([String? errorMessage])
      : super(errorMessage ?? AudioErrorUtils.errMsgAudioOperationFailed);
}

enum AudioErrorCode {
  /// Error code for preset permission denied
  presetPermissionDenied(2100),

  /// Error code for device permission denied
  devicePermissionDenied(2101),

  /// Error code for generic audio operation failure
  audioOperationFailed(2102);

  final int value;
  const AudioErrorCode(this.value);

  static AudioErrorCode fromValue(int value) {
    return AudioErrorCode.values.firstWhere(
      (code) => code.value == value,
      orElse: () => throw ArgumentError('Invalid error code: $value'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'name': toString().split('.').last,
    };
  }

  String toJson() => json.encode(toMap());
}

class AudioErrorUtils extends ErrorStringProvider<AudioError> {
  static const String errMsgPresetPermissionDenied =
      "User does not have permission to share audio in the meeting.";

  static const String errMsgDevicePermissionDenied =
      "Microphone access is denied. Please request permission to use the microphone.";

  static const String errMsgAudioOperationFailed =
      "Audio operation failed. Please try again. If the issue persists, contact support.";

  static final AudioErrorUtils _instance = AudioErrorUtils._internal();
  factory AudioErrorUtils() => _instance;
  AudioErrorUtils._internal();

  static AudioError fromErrorCode({
    required int errorCode,
    String? message,
  }) {
    final code = AudioErrorCode.fromValue(errorCode);

    switch (code) {
      case AudioErrorCode.presetPermissionDenied:
        return const AudioErrorPresetPermissionDenied();

      case AudioErrorCode.devicePermissionDenied:
        return const AudioErrorDevicePermissionDenied();

      case AudioErrorCode.audioOperationFailed:
        return AudioErrorAudioOperationFailed(message);
    }
  }

  static AudioError fromMap(Map<String, dynamic> errorMap) {
    final int errorCode = errorMap['code'] as int? ?? -1;
    final String? message = errorMap['message'] as String?;

    return fromErrorCode(
      errorCode: errorCode,
      message: message,
    );
  }

  @override
  String getErrorClassName(AudioError error) {
    if (error is AudioErrorPresetPermissionDenied) {
      return "PresetPermissionDenied";
    } else if (error is AudioErrorDevicePermissionDenied) {
      return "DevicePermissionDenied";
    } else if (error is AudioErrorAudioOperationFailed) {
      return "AudioOperationFailed";
    } else {
      return "AudioError";
    }
  }

  static AudioErrorCode getErrorCode(AudioError error) {
    if (error is AudioErrorPresetPermissionDenied) {
      return AudioErrorCode.presetPermissionDenied;
    } else if (error is AudioErrorDevicePermissionDenied) {
      return AudioErrorCode.devicePermissionDenied;
    } else if (error is AudioErrorAudioOperationFailed) {
      return AudioErrorCode.audioOperationFailed;
    } else {
      throw ArgumentError('Unknown error type: ${error.runtimeType}');
    }
  }
}
