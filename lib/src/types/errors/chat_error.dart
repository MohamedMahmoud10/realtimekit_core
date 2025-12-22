import 'dart:convert';

import 'package:realtimekit_core_platform_interface/src/types/errors/rtk_error.dart';

class MessageRateLimit {
  final int maxMessages;

  final int intervalInSeconds;

  const MessageRateLimit({
    required this.maxMessages,
    required this.intervalInSeconds,
  });

  Map<String, dynamic> toMap() {
    return {
      'maxMessages': maxMessages,
      'intervalInSeconds': intervalInSeconds,
    };
  }

  String toJson() => json.encode(toMap());

  factory MessageRateLimit.fromMap(Map<String, dynamic> map) {
    return MessageRateLimit(
      maxMessages: map['maxMessages'] as int,
      intervalInSeconds: map['intervalInSeconds'] as int,
    );
  }

  factory MessageRateLimit.fromJson(String source) =>
      MessageRateLimit.fromMap(json.decode(source) as Map<String, dynamic>);
}

abstract class ChatTextError implements RtkError {
  @override
  final String message;

  const ChatTextError(this.message);
}

class ChatTextErrorPermissionDenied extends ChatTextError {
  const ChatTextErrorPermissionDenied(super.errorMessage);
}

class ChatTextErrorMessageIsBlank extends ChatTextError {
  const ChatTextErrorMessageIsBlank()
      : super(ChatErrorUtils.errMsgBlankMessage);
}

class ChatTextErrorCharacterLimitExceeded extends ChatTextError {
  final int characterLimit;

  ChatTextErrorCharacterLimitExceeded(this.characterLimit)
      : super(ChatErrorUtils.getCharLimitReachedMessage(characterLimit));
}

class ChatTextErrorRateLimitBreached extends ChatTextError {
  final MessageRateLimit messageRateLimit;

  final int secondsUntilReset;

  ChatTextErrorRateLimitBreached(this.messageRateLimit, this.secondsUntilReset)
      : super(ChatErrorUtils.getRateLimitBreachedMessage(messageRateLimit));
}

abstract class ChatFileError implements RtkError {
  @override
  final String message;

  const ChatFileError(this.message);
}

class ChatFileErrorPermissionDenied extends ChatFileError {
  const ChatFileErrorPermissionDenied(super.errorMessage);
}

class ChatFileErrorFileFormatNotAllowed extends ChatFileError {
  const ChatFileErrorFileFormatNotAllowed(super.errorMessage);
}

class ChatFileErrorReadFailed extends ChatFileError {
  const ChatFileErrorReadFailed(super.errorMessage);
}

class ChatFileErrorUploadFailed extends ChatFileError {
  const ChatFileErrorUploadFailed()
      : super(ChatErrorUtils.errMsgFileUploadFailed);
}

class ChatFileErrorRateLimitBreached extends ChatFileError {
  final MessageRateLimit messageRateLimit;

  final int secondsUntilReset;

  ChatFileErrorRateLimitBreached(this.messageRateLimit, this.secondsUntilReset)
      : super(ChatErrorUtils.getRateLimitBreachedMessage(messageRateLimit));
}

class ChatConfigError implements RtkError {
  @override
  final String message;

  const ChatConfigError(this.message);
}

enum ChatErrorCode {
  /// Error code for permission denied
  permissionDenied(4000),

  /// Error code for configuration error
  configError(4001),

  /// Error code for rate limit breached
  rateLimitBreached(4002),

  /// Error code for blank message
  blankMessage(4101),

  /// Error code for character limit exceeded
  charLimitExceeded(4102),

  /// Error code for file format not allowed
  fileFormatNotAllowed(4201),

  /// Error code for file read failed
  fileReadFailed(4202),

  /// Error code for file upload failed
  fileUploadFailed(4203);

  final int value;

  const ChatErrorCode(this.value);

  static ChatErrorCode? fromValue(int value) {
    return ChatErrorCode.values.firstWhere(
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

class ChatErrorUtils extends ErrorStringProvider<RtkError> {
  static const String errMsgBlankMessage =
      "Message cannot be empty or only whitespaces.";
  static const String errMsgFileUploadFailed =
      "File upload failed. Please try again later.";
  static const String errMsgPermissionDenied =
      "Permission denied for chat operation.";
  static const String errMsgConfigError = "Chat configuration error.";
  static const String errMsgFileFormatNotAllowed =
      "The specified file format is not allowed.";
  static const String errMsgFileReadFailed =
      "Failed to read the specified file.";

  static String getCharLimitReachedMessage(int characterLimit) {
    return "Message exceeds character limit of $characterLimit characters.";
  }

  static String getRateLimitBreachedMessage(MessageRateLimit messageRateLimit) {
    return "Rate limit of ${messageRateLimit.maxMessages} messages per ${messageRateLimit.intervalInSeconds} seconds reached.";
  }

  static final ChatErrorUtils _instance = ChatErrorUtils._internal();

  factory ChatErrorUtils() => _instance;

  ChatErrorUtils._internal();

  static RtkError fromErrorCode({
    required int errorCode,
    Map<String, dynamic>? additionalParams,
  }) {
    final code = ChatErrorCode.values.firstWhere(
      (c) => c.value == errorCode,
      orElse: () => throw ArgumentError('Invalid error code: $errorCode'),
    );

    switch (code) {
      case ChatErrorCode.permissionDenied:
        if (additionalParams?.containsKey('isFileOperation') == true &&
            additionalParams!['isFileOperation'] == true) {
          return const ChatFileErrorPermissionDenied(
              ChatErrorUtils.errMsgPermissionDenied);
        } else {
          return const ChatTextErrorPermissionDenied(
              ChatErrorUtils.errMsgPermissionDenied);
        }

      case ChatErrorCode.configError:
        return const ChatConfigError(ChatErrorUtils.errMsgConfigError);

      case ChatErrorCode.rateLimitBreached:
        final secondsUntilReset =
            additionalParams?['secondsUntilReset'] as int? ?? 0;
        final maxMessages = additionalParams?['maxMessages'] as int? ?? 10;
        final intervalInSeconds =
            additionalParams?['intervalInSeconds'] as int? ?? 60;

        final messageRateLimit = MessageRateLimit(
          maxMessages: maxMessages,
          intervalInSeconds: intervalInSeconds,
        );

        if (additionalParams?.containsKey('isFileOperation') == true &&
            additionalParams!['isFileOperation'] == true) {
          return ChatFileErrorRateLimitBreached(
              messageRateLimit, secondsUntilReset);
        } else {
          return ChatTextErrorRateLimitBreached(
              messageRateLimit, secondsUntilReset);
        }

      case ChatErrorCode.blankMessage:
        return const ChatTextErrorMessageIsBlank();

      case ChatErrorCode.charLimitExceeded:
        final characterLimit =
            additionalParams?['characterLimit'] as int? ?? 1000;
        return ChatTextErrorCharacterLimitExceeded(characterLimit);

      case ChatErrorCode.fileFormatNotAllowed:
        return const ChatFileErrorFileFormatNotAllowed(
            ChatErrorUtils.errMsgFileFormatNotAllowed);

      case ChatErrorCode.fileReadFailed:
        return const ChatFileErrorReadFailed(
            ChatErrorUtils.errMsgFileReadFailed);

      case ChatErrorCode.fileUploadFailed:
        return const ChatFileErrorUploadFailed();
    }
  }

  static RtkError fromMap(Map<String, dynamic> errorMap) {
    final int errorCode = errorMap['code'] as int? ?? -1;

    final additionalParams = Map<String, dynamic>.from(errorMap);
    additionalParams.remove('code');

    return fromErrorCode(
      errorCode: errorCode,
      additionalParams: additionalParams,
    );
  }

  @override
  String getErrorDataString(RtkError error) {
    if (error is ChatTextErrorRateLimitBreached) {
      return "${super.getErrorDataString(error)}, secondsUntilReset=${error.secondsUntilReset}";
    } else if (error is ChatFileErrorRateLimitBreached) {
      return "${super.getErrorDataString(error)}, secondsUntilReset=${error.secondsUntilReset}";
    } else {
      return super.getErrorDataString(error);
    }
  }

  @override
  String getErrorClassName(RtkError error) {
    if (error is ChatTextError) {
      return _getChatTextErrorClassName(error);
    } else if (error is ChatFileError) {
      return _getChatFileErrorClassName(error);
    } else if (error is ChatConfigError) {
      return "ChatConfigError";
    } else {
      return "ChatError";
    }
  }

  String _getChatTextErrorClassName(ChatTextError error) {
    if (error is ChatTextErrorCharacterLimitExceeded) {
      return "CharacterLimitExceeded";
    } else if (error is ChatTextErrorMessageIsBlank) {
      return "MessageIsBlank";
    } else if (error is ChatTextErrorPermissionDenied) {
      return "PermissionDenied";
    } else if (error is ChatTextErrorRateLimitBreached) {
      return "RateLimitBreached";
    } else {
      return "ChatTextError";
    }
  }

  String _getChatFileErrorClassName(ChatFileError error) {
    if (error is ChatFileErrorFileFormatNotAllowed) {
      return "FileFormatNotAllowed";
    } else if (error is ChatFileErrorPermissionDenied) {
      return "PermissionDenied";
    } else if (error is ChatFileErrorRateLimitBreached) {
      return "RateLimitBreached";
    } else if (error is ChatFileErrorReadFailed) {
      return "ReadFailed";
    } else if (error is ChatFileErrorUploadFailed) {
      return "UploadFailed";
    } else {
      return "ChatFileError";
    }
  }

  static ChatErrorCode getErrorCode(RtkError error) {
    if (error is ChatTextErrorPermissionDenied ||
        error is ChatFileErrorPermissionDenied) {
      return ChatErrorCode.permissionDenied;
    } else if (error is ChatConfigError) {
      return ChatErrorCode.configError;
    } else if (error is ChatTextErrorRateLimitBreached ||
        error is ChatFileErrorRateLimitBreached) {
      return ChatErrorCode.rateLimitBreached;
    } else if (error is ChatTextErrorMessageIsBlank) {
      return ChatErrorCode.blankMessage;
    } else if (error is ChatTextErrorCharacterLimitExceeded) {
      return ChatErrorCode.charLimitExceeded;
    } else if (error is ChatFileErrorFileFormatNotAllowed) {
      return ChatErrorCode.fileFormatNotAllowed;
    } else if (error is ChatFileErrorReadFailed) {
      return ChatErrorCode.fileReadFailed;
    } else if (error is ChatFileErrorUploadFailed) {
      return ChatErrorCode.fileUploadFailed;
    } else {
      throw ArgumentError('Unknown error type: ${error.runtimeType}');
    }
  }
}
