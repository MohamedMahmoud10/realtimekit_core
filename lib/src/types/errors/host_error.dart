import 'dart:convert';

import 'package:realtimekit_core_platform_interface/src/types/errors/rtk_error.dart';

abstract class HostError implements RtkError {
  @override
  final String message;

  const HostError(this.message);
}

class HostErrorKickPermissionDenied extends HostError {
  const HostErrorKickPermissionDenied([String? errorMessage])
      : super(errorMessage ?? HostErrorUtils.errDescKickPermissionDenied);
}

class HostErrorMuteVideoPermissionDenied extends HostError {
  const HostErrorMuteVideoPermissionDenied()
      : super(HostErrorUtils.errDescMuteVideoPermissionDenied);
}

class HostErrorMuteAudioPermissionDenied extends HostError {
  const HostErrorMuteAudioPermissionDenied()
      : super(HostErrorUtils.errDescMuteAudioPermissionDenied);
}

class HostErrorPinPermissionDenied extends HostError {
  const HostErrorPinPermissionDenied()
      : super(HostErrorUtils.errDescPinPermissionDenied);
}

enum HostErrorCode {
  /// Error code for pin permission denied
  pinPermissionDenied(3000),

  /// Error code for mute video permission denied
  muteVideoPermissionDenied(3002),

  /// Error code for mute audio permission denied
  muteAudioPermissionDenied(3003),

  /// Error code for kick permission denied
  kickPermissionDenied(3006);

  final int value;

  const HostErrorCode(this.value);

  static HostErrorCode fromValue(int value) {
    return HostErrorCode.values.firstWhere(
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

class HostErrorUtils extends ErrorStringProvider<HostError> {
  static const String errDescPinPermissionDenied = "Failed to unpin peer";

  static const String errDescMuteVideoPermissionDenied = "Failed to mute video";

  static const String errDescMuteAudioPermissionDenied = "Failed to mute audio";

  static const String errDescKickPermissionDenied = "Failed to kick";

  static final HostErrorUtils _instance = HostErrorUtils._internal();

  factory HostErrorUtils() => _instance;

  HostErrorUtils._internal();

  static HostError fromErrorCode({
    required int errorCode,
    String? message,
  }) {
    final code = HostErrorCode.fromValue(errorCode);

    switch (code) {
      case HostErrorCode.pinPermissionDenied:
        return const HostErrorPinPermissionDenied();

      case HostErrorCode.muteVideoPermissionDenied:
        return const HostErrorMuteVideoPermissionDenied();

      case HostErrorCode.muteAudioPermissionDenied:
        return const HostErrorMuteAudioPermissionDenied();

      case HostErrorCode.kickPermissionDenied:
        return HostErrorKickPermissionDenied(message);
    }
  }

  static HostError fromMap(Map<String, dynamic> errorMap) {
    final int errorCode = errorMap['code'] as int? ?? -1;
    final String? errorMessage = errorMap['message'] as String?;

    return fromErrorCode(
      errorCode: errorCode,
      message: errorMessage,
    );
  }

  @override
  String getErrorClassName(HostError error) {
    if (error is HostErrorKickPermissionDenied) {
      return "KickPermissionDenied";
    } else if (error is HostErrorMuteAudioPermissionDenied) {
      return "MuteAudioPermissionDenied";
    } else if (error is HostErrorMuteVideoPermissionDenied) {
      return "MuteVideoPermissionDenied";
    } else if (error is HostErrorPinPermissionDenied) {
      return "PinPermissionDenied";
    } else {
      return "HostError";
    }
  }

  static HostErrorCode getErrorCode(HostError error) {
    if (error is HostErrorKickPermissionDenied) {
      return HostErrorCode.kickPermissionDenied;
    } else if (error is HostErrorMuteAudioPermissionDenied) {
      return HostErrorCode.muteAudioPermissionDenied;
    } else if (error is HostErrorMuteVideoPermissionDenied) {
      return HostErrorCode.muteVideoPermissionDenied;
    } else if (error is HostErrorPinPermissionDenied) {
      return HostErrorCode.pinPermissionDenied;
    } else {
      throw ArgumentError('Unknown error type: ${error.runtimeType}');
    }
  }
}
