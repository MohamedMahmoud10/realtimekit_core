import 'dart:convert';

import 'package:realtimekit_core_platform_interface/src/utils/int_to_bool_convertor.dart';

import '../enums/socket_state.dart';

class SocketConnectionState {
  final SocketState socketState;
  final bool reconnected;
  final int reconnectionAttempt;
  final bool isReconnectionFailure;

  SocketConnectionState({
    required this.socketState,
    required this.reconnected,
    required this.reconnectionAttempt,
    required this.isReconnectionFailure,
  });

  @override
  String toString() {
    return 'SocketConnectionState(socketState: $socketState, reconnected: $reconnected, reconnectionAttempt: $reconnectionAttempt, isReconnectionFailure: $isReconnectionFailure)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'socketState': socketState.name,
      'reconnected': reconnected,
      'reconnectionAttempt': reconnectionAttempt,
      'isReconnectionFailure': isReconnectionFailure,
    };
  }

  factory SocketConnectionState.fromMap(Map<String, dynamic> map) {
    return SocketConnectionState(
      socketState: SocketState.fromName(map['socketState'] as String),
      reconnected: decodeBool(map['reconnected']),
      reconnectionAttempt: map['reconnectionAttempt'] as int,
      isReconnectionFailure: decodeBool(map['isReconnectionFailure']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SocketConnectionState.fromJson(String source) =>
      SocketConnectionState.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
