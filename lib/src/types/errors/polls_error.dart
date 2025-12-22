import 'dart:convert';

import 'package:realtimekit_core_platform_interface/src/types/errors/rtk_error.dart';

abstract class PollsError implements RtkError {
  @override
  final String message;

  const PollsError(this.message);
}

/// Error for poll creation permission denied
class PollsErrorCreatePollNotAllowed extends PollsError {
  const PollsErrorCreatePollNotAllowed()
      : super(PollsErrorUtils.getCannotCreatePollMessage);
}

/// Error for poll voting permission denied
class PollsErrorVotePollNotAllowed extends PollsError {
  const PollsErrorVotePollNotAllowed()
      : super(PollsErrorUtils.getCannotVoteMessage);
}

/// Error for invalid poll ID
class PollsErrorInvalidPollId extends PollsError {
  const PollsErrorInvalidPollId()
      : super(PollsErrorUtils.getPollIdShouldBeValidMessage);
}

/// Error for empty poll question
class PollsErrorQuestionIsEmpty extends PollsError {
  const PollsErrorQuestionIsEmpty()
      : super(PollsErrorUtils.getInputPollQuestionCannotBeBlankMessage);
}

/// Error for empty poll option
class PollsErrorOptionIsEmpty extends PollsError {
  PollsErrorOptionIsEmpty()
      : super(PollsErrorUtils.getOptionCannotBeBlankMessage());
}

/// Error for insufficient poll options
class PollsErrorMinimumOptionRequired extends PollsError {
  const PollsErrorMinimumOptionRequired()
      : super(PollsErrorUtils.getPollMinimumOptionRequiredMessage);
}

/// Enum for polls error codes
enum PollsErrorCode {
  /// Error code for create poll permission denied
  createPollPermissionDenied(5000),

  /// Error code for input poll question blank
  inputPollQuestionBlank(5001),

  /// Error code for poll options not enough
  pollOptionsNotEnough(5002),

  /// Error code for poll option blank
  pollOptionBlank(5003),

  /// Error code for cannot vote poll
  cannotVotePoll(5004),

  /// Error code for poll ID invalid
  pollIdInvalid(5005);

  /// The integer value of the error code
  final int value;

  const PollsErrorCode(this.value);

  static PollsErrorCode fromValue(int value) {
    return PollsErrorCode.values.firstWhere(
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

/// Utility class for polls error handling
class PollsErrorUtils extends ErrorStringProvider<PollsError> {
  /// Minimum number of options required for a poll
  static const int minimumOptionRequired = 2;

  /// Get message for minimum option required error
  static const String getPollMinimumOptionRequiredMessage =
      "Poll must contain the options/choices greater than $minimumOptionRequired";

  /// Get message for input poll question cannot be blank error
  static const String getInputPollQuestionCannotBeBlankMessage =
      "Poll question can't be blank or empty";

  /// Get message for cannot vote error
  static const String getCannotVoteMessage =
      "You are not allowed to vote on poll, Please check your permissions";

  /// Get message for poll ID should be valid error
  static const String getPollIdShouldBeValidMessage =
      "Passed pollId is Invalid";

  /// Get message for cannot create poll error
  static const String getCannotCreatePollMessage =
      "You are not allowed to create poll, Please check your permissions";

  /// Get message for option cannot be blank error
  static String getOptionCannotBeBlankMessage() {
    return "Poll options/choices can't be blank or empty";
  }

  /// Singleton instance
  static final PollsErrorUtils _instance = PollsErrorUtils._internal();

  /// Factory constructor
  factory PollsErrorUtils() => _instance;

  /// Private constructor
  PollsErrorUtils._internal();

  /// Parse error from error code and message
  ///
  /// Returns the appropriate polls error object based on the error code.
  static PollsError fromErrorCode({
    required int errorCode,
    String? message,
  }) {
    final code = PollsErrorCode.fromValue(errorCode);

    switch (code) {
      case PollsErrorCode.createPollPermissionDenied:
        return const PollsErrorCreatePollNotAllowed();

      case PollsErrorCode.inputPollQuestionBlank:
        return const PollsErrorQuestionIsEmpty();

      case PollsErrorCode.pollOptionsNotEnough:
        return const PollsErrorMinimumOptionRequired();

      case PollsErrorCode.pollOptionBlank:
        return PollsErrorOptionIsEmpty();

      case PollsErrorCode.cannotVotePoll:
        return const PollsErrorVotePollNotAllowed();

      case PollsErrorCode.pollIdInvalid:
        return const PollsErrorInvalidPollId();
    }
  }

  /// Parse error from a map containing error details
  ///
  /// The map should contain at least 'code' (int) key.
  /// Additional parameters can be included in the map for specific error types.
  static PollsError fromMap(Map<String, dynamic> errorMap) {
    final int errorCode = errorMap['code'] as int? ?? -1;

    return fromErrorCode(
      errorCode: errorCode,
    );
  }

  @override
  String getErrorClassName(PollsError error) {
    if (error is PollsErrorCreatePollNotAllowed) {
      return "CreatePollNotAllowed";
    } else if (error is PollsErrorVotePollNotAllowed) {
      return "VotePollNotAllowed";
    } else if (error is PollsErrorQuestionIsEmpty) {
      return "QuestionIsEmpty";
    } else if (error is PollsErrorOptionIsEmpty) {
      return "OptionIsEmpty";
    } else if (error is PollsErrorMinimumOptionRequired) {
      return "MinimumOptionRequired";
    } else if (error is PollsErrorInvalidPollId) {
      return "InvalidPollId";
    } else {
      return "PollsError";
    }
  }

  /// Get error code for a given error
  static PollsErrorCode getErrorCode(PollsError error) {
    if (error is PollsErrorCreatePollNotAllowed) {
      return PollsErrorCode.createPollPermissionDenied;
    } else if (error is PollsErrorVotePollNotAllowed) {
      return PollsErrorCode.cannotVotePoll;
    } else if (error is PollsErrorQuestionIsEmpty) {
      return PollsErrorCode.inputPollQuestionBlank;
    } else if (error is PollsErrorOptionIsEmpty) {
      return PollsErrorCode.pollOptionBlank;
    } else if (error is PollsErrorMinimumOptionRequired) {
      return PollsErrorCode.pollOptionsNotEnough;
    } else if (error is PollsErrorInvalidPollId) {
      return PollsErrorCode.pollIdInvalid;
    } else {
      throw ArgumentError('Unknown error type: ${error.runtimeType}');
    }
  }
}
