import 'dart:convert';

import 'package:realtimekit_core_platform_interface/src/enums/rtk_stage_status.dart';
import 'package:realtimekit_core_platform_interface/src/types/errors/rtk_error.dart';
import 'package:realtimekit_core_platform_interface/src/types/rtk_meta.dart';

abstract class StageError implements RtkError {
  @override
  final String message;

  const StageError(this.message);
}

class StageErrorStageDisabledForMeetingType extends StageError {
  final RtkMeetingType meetingType;

  const StageErrorStageDisabledForMeetingType(this.meetingType)
      : super(StageErrorUtils.errMsgStageDisabled);
}

class StageErrorPermissionDenied extends StageError {
  const StageErrorPermissionDenied(super.errorMessage);
}

class StageErrorActionInvalidForStageStatus extends StageError {
  final StageStatus stageStatus;

  StageErrorActionInvalidForStageStatus(this.stageStatus, String errorMessage)
      : super(errorMessage);
}

class StageErrorNoRequestToCancel extends StageError {
  const StageErrorNoRequestToCancel()
      : super(StageErrorUtils.errMsgNoRequestToCancel);
}

enum StageErrorCode {
  stageDisabledForMeetingType(8000),
  permissionDenied(8001),
  noRequestToCancel(8003),
  actionInvalidForStageStatus(8004);

  final int value;
  const StageErrorCode(this.value);

  static StageErrorCode fromValue(int value) {
    return StageErrorCode.values.firstWhere(
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

class StageErrorUtils extends ErrorStringProvider<StageError> {
  static const String errMsgRequestPermissionDenied =
      "User does not have permission to request stage access. Please allow it in the user's preset.";

  static const String errMsgJoinPermissionDenied =
      "Stage access denied. Ensure the user is allowed in their preset or granted access by a host.";

  static const String errMsgGrantAccessPermissionDenied =
      "User does not have host permission to grant stage access. Please enable it their preset.";

  static const String errMsgDenyAccessPermissionDenied =
      "User does not have host permission to deny stage access. Please enable it their preset.";

  static const String errMsgKickPermissionDenied =
      "User does not have host permission to kick users off the stage. Please enable it in their preset.";

  static const String errMsgNoRequestToCancel =
      "User has not requested stage access.";

  static const String errMsgStageDisabled =
      "Stage is disabled for this meeting type. Please use a WEBINAR or LIVESTREAM meeting";

  static final StageErrorUtils _instance = StageErrorUtils._internal();
  factory StageErrorUtils() => _instance;
  StageErrorUtils._internal();

  static String getRequestAccessInvalidErrorMessage(StageStatus stageStatus) =>
      "Request access is not allowed when the user is already $stageStatus.";

  static String getLeaveInvalidErrorMessage(StageStatus stageStatus) =>
      "Cannot leave stage when the user is already $stageStatus.";

  static StageError fromErrorCode({
    required int errorCode,
    String? message,
    RtkMeetingType? meetingType,
    StageStatus? stageStatus,
  }) {
    final code = StageErrorCode.fromValue(errorCode);

    switch (code) {
      case StageErrorCode.stageDisabledForMeetingType:
        return StageErrorStageDisabledForMeetingType(
            meetingType ?? RtkMeetingType.groupCall);

      case StageErrorCode.permissionDenied:
        return StageErrorPermissionDenied(
            message ?? errMsgRequestPermissionDenied);

      case StageErrorCode.noRequestToCancel:
        return const StageErrorNoRequestToCancel();

      case StageErrorCode.actionInvalidForStageStatus:
        return StageErrorActionInvalidForStageStatus(
          stageStatus ?? StageStatus.offStage,
          message ??
              getRequestAccessInvalidErrorMessage(
                  stageStatus ?? StageStatus.offStage),
        );
    }
  }

  static StageError fromMap(Map<String, dynamic> errorMap) {
    final int errorCode = errorMap['code'] as int? ?? -1;
    final String? message = errorMap['message'] as String?;
    final String? meetingTypeStr = errorMap['meetingType'] as String?;
    final String? stageStatusStr = errorMap['stageStatus'] as String?;

    return fromErrorCode(
      errorCode: errorCode,
      message: message,
      meetingType: meetingTypeStr != null
          ? RtkMeetingType.fromName(meetingTypeStr)
          : null,
      stageStatus:
          stageStatusStr != null ? StageStatus.fromName(stageStatusStr) : null,
    );
  }

  @override
  String getErrorClassName(StageError error) {
    if (error is StageErrorActionInvalidForStageStatus) {
      return "ActionInvalidForStageStatus";
    } else if (error is StageErrorPermissionDenied) {
      return "PermissionDenied";
    } else if (error is StageErrorStageDisabledForMeetingType) {
      return "StageDisabledForMeetingType";
    } else if (error is StageErrorNoRequestToCancel) {
      return "NoRequestToCancel";
    } else {
      return "StageError";
    }
  }

  @override
  String getErrorDataString(StageError error) {
    if (error is StageErrorActionInvalidForStageStatus) {
      return "${super.getErrorDataString(error)}, stageStatus=${error.stageStatus}";
    } else if (error is StageErrorStageDisabledForMeetingType) {
      return "${super.getErrorDataString(error)}, meetingType=${error.meetingType}";
    } else {
      return super.getErrorDataString(error);
    }
  }

  static StageErrorCode getErrorCode(StageError error) {
    if (error is StageErrorStageDisabledForMeetingType) {
      return StageErrorCode.stageDisabledForMeetingType;
    } else if (error is StageErrorPermissionDenied) {
      return StageErrorCode.permissionDenied;
    } else if (error is StageErrorNoRequestToCancel) {
      return StageErrorCode.noRequestToCancel;
    } else if (error is StageErrorActionInvalidForStageStatus) {
      return StageErrorCode.actionInvalidForStageStatus;
    } else {
      throw ArgumentError('Unknown error type: ${error.runtimeType}');
    }
  }
}
