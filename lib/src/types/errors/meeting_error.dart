import 'dart:convert';

import 'package:realtimekit_core_platform_interface/src/types/errors/rtk_error.dart';

abstract class MeetingError implements RtkError {
  @override
  final String message;

  const MeetingError(this.message);
}

class InvalidAuthTokenError extends MeetingError {
  const InvalidAuthTokenError()
      : super(MeetingErrorUtils.errDescInvalidAuthToken);
}

class MeetingInitFailedError extends MeetingError {
  const MeetingInitFailedError([String? errorMessage])
      : super(errorMessage ?? MeetingErrorUtils.errDescMeetingInitFailed);
}

class InvalidBaseUrlError extends MeetingError {
  const InvalidBaseUrlError() : super(MeetingErrorUtils.errDescInvalidBaseUrl);
}

class JoinRoomFailedError extends MeetingError {
  const JoinRoomFailedError() : super(MeetingErrorUtils.errDescJoinRoomFailed);
}

class UnauthorisedParticipantError extends MeetingError {
  const UnauthorisedParticipantError()
      : super(MeetingErrorUtils.errDescUnauthorisedParticipant);
}

class InactiveMeetingError extends MeetingError {
  const InactiveMeetingError()
      : super(MeetingErrorUtils.errDescInactiveMeeting);
}

class UnknownError extends MeetingError {
  const UnknownError() : super(MeetingErrorUtils.errDescUnknownError);
}

enum MeetingErrorCode {
  /// Error code for invalid auth token
  invalidAuthToken(1000),

  /// Error code for meeting initialization failure
  meetingInitFailed(1001),

  /// Error code for invalid base URL
  invalidBaseUrl(1002),

  /// Error code for join room failure
  joinRoomFailed(1003),

  /// Error code for unauthorized participant
  unauthorisedParticipant(1004),

  /// Error code for inactive meeting
  inactiveMeeting(1005),

  /// Error code for unknown error
  unknownError(1006);

  final int value;

  const MeetingErrorCode(this.value);

  static MeetingErrorCode fromValue(int value) {
    return MeetingErrorCode.values.firstWhere(
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

class MeetingErrorUtils extends ErrorStringProvider<MeetingError> {
  static const String errDescInvalidAuthToken = "Invalid auth token";

  static const String errDescMeetingInitFailed = "Failed to initialize meeting";

  static const String errDescInvalidBaseUrl = "Invalid base url";

  static const String errDescJoinRoomFailed = "Failed to join room";

  static const String errDescUnauthorisedParticipant =
      "Unauthorised participant. Please check the auth-token.";

  static const String errDescInactiveMeeting =
      "Meeting is INACTIVE, cannot join.";

  static const String errDescUnknownError = "Something went wrong";

  static final MeetingErrorUtils _instance = MeetingErrorUtils._internal();

  factory MeetingErrorUtils() => _instance;

  MeetingErrorUtils._internal();

  static MeetingError fromErrorCode({
    required int errorCode,
    String? message,
  }) {
    final code = MeetingErrorCode.fromValue(errorCode);

    switch (code) {
      case MeetingErrorCode.invalidAuthToken:
        return const InvalidAuthTokenError();

      case MeetingErrorCode.meetingInitFailed:
        return MeetingInitFailedError(message);

      case MeetingErrorCode.invalidBaseUrl:
        return const InvalidBaseUrlError();

      case MeetingErrorCode.joinRoomFailed:
        return const JoinRoomFailedError();

      case MeetingErrorCode.unauthorisedParticipant:
        return const UnauthorisedParticipantError();

      case MeetingErrorCode.inactiveMeeting:
        return const InactiveMeetingError();

      case MeetingErrorCode.unknownError:
        return const UnknownError();
    }
  }

  static MeetingError fromMap(Map<String, dynamic> errorMap) {
    final int errorCode =
        errorMap['code'] as int? ?? MeetingErrorCode.unknownError.value;
    final String? errorMessage = errorMap['message'] as String?;

    return fromErrorCode(
      errorCode: errorCode,
      message: errorMessage,
    );
  }

  @override
  String getErrorClassName(MeetingError error) {
    if (error is InvalidAuthTokenError) {
      return "InvalidAuthToken";
    } else if (error is MeetingInitFailedError) {
      return "MeetingInitFailed";
    } else if (error is InvalidBaseUrlError) {
      return "InvalidBaseUrl";
    } else if (error is JoinRoomFailedError) {
      return "JoinRoomFailed";
    } else if (error is UnauthorisedParticipantError) {
      return "UnauthorisedParticipant";
    } else if (error is InactiveMeetingError) {
      return "InactiveMeeting";
    } else if (error is UnknownError) {
      return "UnknownError";
    } else {
      return "MeetingError";
    }
  }

  static MeetingErrorCode getErrorCode(MeetingError error) {
    if (error is InvalidAuthTokenError) {
      return MeetingErrorCode.invalidAuthToken;
    } else if (error is MeetingInitFailedError) {
      return MeetingErrorCode.meetingInitFailed;
    } else if (error is InvalidBaseUrlError) {
      return MeetingErrorCode.invalidBaseUrl;
    } else if (error is JoinRoomFailedError) {
      return MeetingErrorCode.joinRoomFailed;
    } else if (error is UnauthorisedParticipantError) {
      return MeetingErrorCode.unauthorisedParticipant;
    } else if (error is InactiveMeetingError) {
      return MeetingErrorCode.inactiveMeeting;
    } else if (error is UnknownError) {
      return MeetingErrorCode.unknownError;
    } else {
      throw ArgumentError('Unknown error type: ${error.runtimeType}');
    }
  }
}
