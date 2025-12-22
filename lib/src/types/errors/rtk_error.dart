abstract class RtkError implements Exception {
  String get message;
}

typedef OnResult = void Function(RtkError? error);

abstract class ErrorStringProvider<T extends RtkError> {
  String errorToString(T error) {
    final className = getErrorClassName(error);
    final dataString = getErrorDataString(error);
    return "$className($dataString)";
  }

  String getErrorClassName(T error);

  String getErrorDataString(T error) {
    return getErrorDataStringImpl(error);
  }
}

String getErrorDataStringImpl(RtkError error) {
  return "message: ${error.message}";
}
