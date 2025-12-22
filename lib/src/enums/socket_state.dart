enum SocketState {
  connected('connected'),
  disconnected('disconnected'),
  reconnecting('reconnecting'),
  failed('failed'),
  unknown('unknown');

  final String name;
  const SocketState(this.name);

  static SocketState fromName(String name) {
    switch (name) {
      case 'connected':
        return SocketState.connected;
      case 'disconnected':
        return SocketState.disconnected;
      case 'reconnecting':
        return SocketState.reconnecting;
      case 'failed':
        return SocketState.failed;
      default:
        return SocketState.unknown;
    }
  }
}
