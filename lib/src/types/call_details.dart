import 'dart:convert';

class CallDetails {
  final String name;
  final dynamic args;
  CallDetails({
    required this.name,
    required this.args,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'args': args,
    };
  }

  factory CallDetails.fromMap(Map<String, dynamic> map) {
    return CallDetails(
      name: map['name'] as String,
      args: map['args'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory CallDetails.fromJson(String source) =>
      CallDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CallDetails(name: $name, args: $args)';

  @override
  bool operator ==(covariant CallDetails other) {
    if (identical(this, other)) return true;

    return other.name == name && other.args == args;
  }

  @override
  int get hashCode => name.hashCode ^ args.hashCode;
}
