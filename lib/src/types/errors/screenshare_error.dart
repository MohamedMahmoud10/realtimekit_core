import 'dart:convert';

import 'package:realtimekit_core_platform_interface/src/types/errors/rtk_error.dart';
import 'package:realtimekit_core_platform_interface/src/types/rtk_meta.dart';

abstract class ScreenShareError implements RtkError {
  @override
  final String message;

  const ScreenShareError(this.message);
}

class ScreenShareErrorPresetPermissionDenied extends ScreenShareError {
  const ScreenShareErrorPresetPermissionDenied()
      : super(ScreenShareErrorUtils.errMsgPresetPermissionDenied);
}

class ScreenShareErrorMaxActiveScreenSharesReached extends ScreenShareError {
  final int maxAllowedScreenShares;

  ScreenShareErrorMaxActiveScreenSharesReached(this.maxAllowedScreenShares)
      : super(ScreenShareErrorUtils.getMaxActiveScreenSharesReachedMessage(
            maxAllowedScreenShares));
}

class ScreenShareErrorUnsupportedForMeetingType extends ScreenShareError {
  final RtkMeetingType meetingType;

  ScreenShareErrorUnsupportedForMeetingType(this.meetingType)
      : super(ScreenShareErrorUtils.getUnsupportedForMeetingTypeMessage(
            meetingType));
}

enum ScreenShareErrorCode {
  /// Error code for preset permission denied
  presetPermissionDenied(2300),

  /// Error code for maximum active screenshares reached
  maxActiveScreenSharesReached(2303),

  /// Error code for unsupported meeting type
  unsupportedForMeetingType(2304);

  final int value;
  const ScreenShareErrorCode(this.value);

  static ScreenShareErrorCode fromValue(int value) {
    return ScreenShareErrorCode.values.firstWhere(
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

class ScreenShareErrorUtils extends ErrorStringProvider<ScreenShareError> {
  static const String errMsgPresetPermissionDenied =
      "User does not have permission to share their screen in the meeting.";

  static final ScreenShareErrorUtils _instance =
      ScreenShareErrorUtils._internal();
  factory ScreenShareErrorUtils() => _instance;
  ScreenShareErrorUtils._internal();

  static String getUnsupportedForMeetingTypeMessage(
    RtkMeetingType meetingType,
  ) =>
      "Cannot share screen in an $meetingType type meeting. Please use a Preset that supports screen sharing.";

  static String getMaxActiveScreenSharesReachedMessage(
    int maxAllowedScreenShares,
  ) =>
      "Cannot start screen sharing. The maximum limit of $maxAllowedScreenShares active screen shares has been reached.";

  static ScreenShareError fromErrorCode({
    required int errorCode,
    String? message,
    RtkMeetingType? meetingType,
    int? maxAllowedScreenShares,
  }) {
    final code = ScreenShareErrorCode.fromValue(errorCode);

    switch (code) {
      case ScreenShareErrorCode.presetPermissionDenied:
        return const ScreenShareErrorPresetPermissionDenied();

      case ScreenShareErrorCode.maxActiveScreenSharesReached:
        return ScreenShareErrorMaxActiveScreenSharesReached(
            maxAllowedScreenShares ?? 1);

      case ScreenShareErrorCode.unsupportedForMeetingType:
        return ScreenShareErrorUnsupportedForMeetingType(
            meetingType ?? RtkMeetingType.groupCall);
    }
  }

  static ScreenShareError fromMap(Map<String, dynamic> errorMap) {
    final int errorCode = errorMap['code'] as int? ?? -1;
    final String? message = errorMap['message'] as String?;
    final String? meetingTypeStr = errorMap['meetingType'] as String?;
    final int? maxAllowedScreenShares =
        errorMap['maxAllowedScreenShares'] as int?;

    return fromErrorCode(
      errorCode: errorCode,
      message: message,
      meetingType: meetingTypeStr != null
          ? RtkMeetingType.fromName(meetingTypeStr)
          : null,
      maxAllowedScreenShares: maxAllowedScreenShares,
    );
  }

  @override
  String getErrorClassName(ScreenShareError error) {
    if (error is ScreenShareErrorPresetPermissionDenied) {
      return "PresetPermissionDenied";
    } else if (error is ScreenShareErrorMaxActiveScreenSharesReached) {
      return "MaxActiveScreenSharesReached";
    } else if (error is ScreenShareErrorUnsupportedForMeetingType) {
      return "UnsupportedForMeetingType";
    } else {
      return "ScreenShareError";
    }
  }

  @override
  String getErrorDataString(ScreenShareError error) {
    if (error is ScreenShareErrorMaxActiveScreenSharesReached) {
      return "${super.getErrorDataString(error)}, maxAllowedScreenShares=${error.maxAllowedScreenShares}";
    } else if (error is ScreenShareErrorUnsupportedForMeetingType) {
      return "${super.getErrorDataString(error)}, meetingType=${error.meetingType}";
    } else {
      return super.getErrorDataString(error);
    }
  }

  static ScreenShareErrorCode getErrorCode(ScreenShareError error) {
    if (error is ScreenShareErrorPresetPermissionDenied) {
      return ScreenShareErrorCode.presetPermissionDenied;
    } else if (error is ScreenShareErrorMaxActiveScreenSharesReached) {
      return ScreenShareErrorCode.maxActiveScreenSharesReached;
    } else if (error is ScreenShareErrorUnsupportedForMeetingType) {
      return ScreenShareErrorCode.unsupportedForMeetingType;
    } else {
      throw ArgumentError('Unknown error type: ${error.runtimeType}');
    }
  }
}
