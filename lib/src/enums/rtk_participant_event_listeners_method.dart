enum RtkParticipantEventListenerMethod {
  onParticipantJoin("onParticipantJoin"),
  onParticipantLeave("onParticipantLeave"),
  onScreenShareUpdate("onScreenShareUpdate"),
  onAudioUpdate("onAudioUpdate"),
  onVideoUpdate("onVideoUpdate"),
  onActiveSpeakerChanged("onActiveSpeakerChanged"),
  onParticipantPinned("onParticipantPinned"),
  onParticipantUnpinned("onParticipantUnpinned"),
  onUpdate("onUpdate"),
  onActiveParticipantsChanged("onActiveParticipantsChanged"),
  onNewBroadcastMessage("onNewBroadcastMessage"),
  unknown("unknown");

  final String name;
  const RtkParticipantEventListenerMethod(this.name);

  static RtkParticipantEventListenerMethod fromName(String name) {
    switch (name) {
      case 'onAudioUpdate':
        return RtkParticipantEventListenerMethod.onAudioUpdate;
      case 'onActiveSpeakerChanged':
        return RtkParticipantEventListenerMethod.onActiveSpeakerChanged;
      case 'onParticipantJoin':
        return RtkParticipantEventListenerMethod.onParticipantJoin;
      case 'onParticipantLeave':
        return RtkParticipantEventListenerMethod.onParticipantLeave;
      case 'onParticipantPinned':
        return RtkParticipantEventListenerMethod.onParticipantPinned;
      case 'onParticipantUnpinned':
        return RtkParticipantEventListenerMethod.onParticipantUnpinned;
      case 'onScreenShareUpdate':
        return RtkParticipantEventListenerMethod.onScreenShareUpdate;
      case 'onVideoUpdate':
        return RtkParticipantEventListenerMethod.onVideoUpdate;
      case 'onUpdate':
        return RtkParticipantEventListenerMethod.onUpdate;
      case 'onActiveParticipantsChanged':
        return RtkParticipantEventListenerMethod.onActiveParticipantsChanged;
      case 'onNewBroadcastMessage':
        return RtkParticipantEventListenerMethod.onNewBroadcastMessage;
      default:
        return RtkParticipantEventListenerMethod.unknown;
    }
  }
}
