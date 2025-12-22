import 'dart:convert';

import 'package:realtimekit_core_platform_interface/src/types/errors/rtk_error.dart';

abstract class PluginError implements RtkError {
  @override
  final String message;

  const PluginError(this.message);
}

class PluginErrorPermissionDenied extends PluginError {
  const PluginErrorPermissionDenied(super.errorMessage);
}

class PluginErrorNotActive extends PluginError {
  const PluginErrorNotActive() : super(PluginErrorUtils.errMsgPluginNotActive);
}

enum PluginErrorCode {
  permissionDenied(6000),
  notActive(6001);

  final int value;
  const PluginErrorCode(this.value);

  static PluginErrorCode fromValue(int value) {
    return PluginErrorCode.values.firstWhere(
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

class PluginErrorUtils extends ErrorStringProvider<PluginError> {
  static const String errMsgLaunchPermissionDenied =
      "User does have permission to launch plugins. Please allow it in the user's preset.";

  static const String errMsgClosePermissionDenied =
      "User does have permission to close plugins. Please allow it in the user's preset.";

  static const String errMsgPluginNotActive =
      "Cannot send data. The plugin is inactive.";

  static final PluginErrorUtils _instance = PluginErrorUtils._internal();
  factory PluginErrorUtils() => _instance;
  PluginErrorUtils._internal();

  static PluginError fromErrorCode({
    required int errorCode,
    String? message,
  }) {
    final code = PluginErrorCode.fromValue(errorCode);

    switch (code) {
      case PluginErrorCode.permissionDenied:
        return PluginErrorPermissionDenied(
            message ?? errMsgLaunchPermissionDenied);

      case PluginErrorCode.notActive:
        return const PluginErrorNotActive();
    }
  }

  static PluginError fromMap(Map<String, dynamic> errorMap) {
    final int errorCode = errorMap['code'] as int? ?? -1;
    final String? message = errorMap['message'] as String?;

    return fromErrorCode(
      errorCode: errorCode,
      message: message,
    );
  }

  @override
  String getErrorClassName(PluginError error) {
    if (error is PluginErrorNotActive) {
      return "NotActive";
    } else if (error is PluginErrorPermissionDenied) {
      return "PermissionDenied";
    } else {
      return "PluginError";
    }
  }

  static PluginErrorCode getErrorCode(PluginError error) {
    if (error is PluginErrorPermissionDenied) {
      return PluginErrorCode.permissionDenied;
    } else if (error is PluginErrorNotActive) {
      return PluginErrorCode.notActive;
    } else {
      throw ArgumentError('Unknown error type: ${error.runtimeType}');
    }
  }
}
