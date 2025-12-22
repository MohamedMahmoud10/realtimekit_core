import 'dart:convert';

import 'package:realtimekit_core_platform_interface/src/types/errors/rtk_error.dart';

abstract class RecordingError implements RtkError {
  @override
  final String message;

  const RecordingError(this.message);
}

class RecordingErrorPermissionDenied extends RecordingError {
  RecordingErrorPermissionDenied()
      : super(RecordingErrorUtils.getErrorString(
            RecordingErrorUtils.errCodePermissionDenied));
}

class RecordingErrorOperationFailed extends RecordingError {
  RecordingErrorOperationFailed(super.errorMessage);
}

class RecordingErrorRecordingNotFound extends RecordingError {
  RecordingErrorRecordingNotFound()
      : super(RecordingErrorUtils.getErrorString(
            RecordingErrorUtils.errCodeNoRec));
}

class RecordingErrorInvalidState extends RecordingError {
  RecordingErrorInvalidState()
      : super(RecordingErrorUtils.getErrorString(
            RecordingErrorUtils.errCodeInvalidState));
}

enum RecordingErrorCode {
  /// Error code for recording permission denied
  permissionDenied(7000),

  /// Error code for recording operation failed
  operationFailed(7001),

  /// Error code for no recording in progress
  noRecording(7002),

  /// Error code for invalid recording state
  invalidState(7003);

  final int value;

  const RecordingErrorCode(this.value);

  static RecordingErrorCode fromValue(int value) {
    return RecordingErrorCode.values.firstWhere(
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

class RecordingErrorUtils extends ErrorStringProvider<RecordingError> {
  static const int errCodePermissionDenied = 7000;
  static const int errCodeOperationFailed = 7001;
  static const int errCodeNoRec = 7002;
  static const int errCodeInvalidState = 7003;

  static const String startException = "Recording start exception.";
  static const String stopException = "Recording stop exception.";
  static const String resumeException = "Recording resume exception.";
  static const String pauseException = "Recording pause exception.";

  static String getErrorString(int errorCode) {
    switch (errorCode) {
      case errCodePermissionDenied:
        return "Record permission is not given on preset editor.";
      case errCodeOperationFailed:
        return "Operation failed on recording.";
      case errCodeNoRec:
        return "There is no recording in progress.";
      case errCodeInvalidState:
        return "Invalid recording state.";
      default:
        return "Failed to execute operation.";
    }
  }

  static final RecordingErrorUtils _instance = RecordingErrorUtils._internal();

  factory RecordingErrorUtils() => _instance;

  RecordingErrorUtils._internal();

  static RecordingError fromErrorCode({
    required int errorCode,
    String? message,
  }) {
    final code = RecordingErrorCode.fromValue(errorCode);

    switch (code) {
      case RecordingErrorCode.permissionDenied:
        return RecordingErrorPermissionDenied();

      case RecordingErrorCode.operationFailed:
        return RecordingErrorOperationFailed(
            message ?? getErrorString(errCodeOperationFailed));

      case RecordingErrorCode.noRecording:
        return RecordingErrorRecordingNotFound();

      case RecordingErrorCode.invalidState:
        return RecordingErrorInvalidState();
    }
  }

  static RecordingError fromMap(Map<String, dynamic> errorMap) {
    final int errorCode = errorMap['code'] as int? ?? -1;
    final String? errorMessage = errorMap['message'] as String?;

    return fromErrorCode(
      errorCode: errorCode,
      message: errorMessage,
    );
  }

  @override
  String getErrorClassName(RecordingError error) {
    if (error is RecordingErrorPermissionDenied) {
      return "PermissionDenied";
    } else if (error is RecordingErrorOperationFailed) {
      return "OperationFailed";
    } else if (error is RecordingErrorRecordingNotFound) {
      return "RecordingNotFound";
    } else if (error is RecordingErrorInvalidState) {
      return "InvalidState";
    } else {
      return "RecordingError";
    }
  }

  static RecordingErrorCode getErrorCode(RecordingError error) {
    if (error is RecordingErrorPermissionDenied) {
      return RecordingErrorCode.permissionDenied;
    } else if (error is RecordingErrorOperationFailed) {
      return RecordingErrorCode.operationFailed;
    } else if (error is RecordingErrorRecordingNotFound) {
      return RecordingErrorCode.noRecording;
    } else if (error is RecordingErrorInvalidState) {
      return RecordingErrorCode.invalidState;
    } else {
      throw ArgumentError('Unknown error type: ${error.runtimeType}');
    }
  }
}
