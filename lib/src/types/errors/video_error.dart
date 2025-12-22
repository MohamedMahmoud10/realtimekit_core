import 'dart:convert';

import 'package:realtimekit_core_platform_interface/src/types/errors/rtk_error.dart';
import 'package:realtimekit_core_platform_interface/src/types/rtk_meta.dart';

abstract class VideoError implements RtkError {
  @override
  final String message;

  const VideoError(this.message);
}

class VideoErrorPresetPermissionDenied extends VideoError {
  const VideoErrorPresetPermissionDenied()
      : super(VideoErrorUtils.errMsgPresetPermissionDenied);
}

class VideoErrorDevicePermissionDenied extends VideoError {
  const VideoErrorDevicePermissionDenied()
      : super(VideoErrorUtils.errMsgDevicePermissionDenied);
}

class VideoErrorVideoOperationFailed extends VideoError {
  const VideoErrorVideoOperationFailed([String? errorMessage])
      : super(errorMessage ?? VideoErrorUtils.errMsgVideoOperationFailed);
}

class VideoErrorUnsupportedForMeetingType extends VideoError {
  final RtkMeetingType meetingType;

  VideoErrorUnsupportedForMeetingType(this.meetingType)
      : super(VideoErrorUtils.getUnsupportedForMeetingTypeMessage(meetingType));
}

enum VideoErrorCode {
  /// Error code for preset permission denied
  presetPermissionDenied(2200),

  /// Error code for device permission denied
  devicePermissionDenied(2201),

  /// Error code for generic video operation failure
  videoOperationFailed(2202),

  /// Error code for unsupported meeting type
  unsupportedForMeetingType(2203);

  final int value;
  const VideoErrorCode(this.value);

  static VideoErrorCode fromValue(int value) {
    return VideoErrorCode.values.firstWhere(
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

class VideoErrorUtils extends ErrorStringProvider<VideoError> {
  static const String errMsgPresetPermissionDenied =
      "User does not have permission to share video in the meeting.";

  static const String errMsgDevicePermissionDenied =
      "Camera access is denied. Please request permission to use the camera.";

  static const String errMsgVideoOperationFailed =
      "Video operation failed. Please try again. If the issue persists, contact support.";

  static final VideoErrorUtils _instance = VideoErrorUtils._internal();
  factory VideoErrorUtils() => _instance;
  VideoErrorUtils._internal();

  static String getUnsupportedForMeetingTypeMessage(
    RtkMeetingType meetingType,
  ) =>
      "Cannot share video in an $meetingType type meeting. Please use a Preset that supports video sharing.";
  static VideoError fromErrorCode({
    required int errorCode,
    String? message,
    RtkMeetingType? meetingType,
  }) {
    final code = VideoErrorCode.fromValue(errorCode);

    switch (code) {
      case VideoErrorCode.presetPermissionDenied:
        return const VideoErrorPresetPermissionDenied();

      case VideoErrorCode.devicePermissionDenied:
        return const VideoErrorDevicePermissionDenied();

      case VideoErrorCode.videoOperationFailed:
        return VideoErrorVideoOperationFailed(message);

      case VideoErrorCode.unsupportedForMeetingType:
        return VideoErrorUnsupportedForMeetingType(
            meetingType ?? RtkMeetingType.groupCall);
    }
  }

  static VideoError fromMap(Map<String, dynamic> errorMap) {
    final int errorCode = errorMap['code'] as int? ?? -1;
    final String? message = errorMap['message'] as String?;
    final String? meetingTypeStr = errorMap['meetingType'] as String?;

    return fromErrorCode(
      errorCode: errorCode,
      message: message,
      meetingType: meetingTypeStr != null
          ? RtkMeetingType.fromName(meetingTypeStr)
          : null,
    );
  }

  @override
  String getErrorClassName(VideoError error) {
    if (error is VideoErrorPresetPermissionDenied) {
      return "PresetPermissionDenied";
    } else if (error is VideoErrorDevicePermissionDenied) {
      return "DevicePermissionDenied";
    } else if (error is VideoErrorUnsupportedForMeetingType) {
      return "UnsupportedForMeetingType";
    } else if (error is VideoErrorVideoOperationFailed) {
      return "VideoOperationFailed";
    } else {
      return "VideoError";
    }
  }

  @override
  String getErrorDataString(VideoError error) {
    if (error is VideoErrorUnsupportedForMeetingType) {
      return "${super.getErrorDataString(error)}, meetingType=${error.meetingType}";
    } else {
      return super.getErrorDataString(error);
    }
  }

  static VideoErrorCode getErrorCode(VideoError error) {
    if (error is VideoErrorPresetPermissionDenied) {
      return VideoErrorCode.presetPermissionDenied;
    } else if (error is VideoErrorDevicePermissionDenied) {
      return VideoErrorCode.devicePermissionDenied;
    } else if (error is VideoErrorVideoOperationFailed) {
      return VideoErrorCode.videoOperationFailed;
    } else if (error is VideoErrorUnsupportedForMeetingType) {
      return VideoErrorCode.unsupportedForMeetingType;
    } else {
      throw ArgumentError('Unknown error type: ${error.runtimeType}');
    }
  }
}
