import 'dart:convert';

class RtkException {
  final bool success;
  final Error error;

  RtkException({required this.success, required this.error});

  factory RtkException.fromJson(String str) =>
      RtkException.fromMap(json.decode(str));

  factory RtkException.fromMap(Map<String, dynamic> json) => RtkException(
    success: json["success"],
    error: Error.fromMap(json["error"]),
  );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {"success": success, "error": error.toMap()};
}

class Error {
  final int code;
  final String message;

  Error({required this.code, required this.message});

  factory Error.fromJson(String str) => Error.fromMap(json.decode(str));

  factory Error.fromMap(Map<String, dynamic> json) =>
      Error(code: json["code"], message: json["message"]);

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {"code": code, "message": message};
}
