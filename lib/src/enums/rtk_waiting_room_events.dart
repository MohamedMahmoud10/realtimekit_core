enum RtkWaitlistedParticipantEvents {
  onWaitListParticipantAccepted('onWaitListParticipantAccepted'),
  onWaitListParticipantClosed('onWaitListParticipantClosed'),
  onWaitListParticipantJoined('onWaitListParticipantJoined'),
  onWaitListParticipantRejected('onWaitListParticipantRejected'),
  unknown('unknown');

  final String value;
  const RtkWaitlistedParticipantEvents(this.value);
  static RtkWaitlistedParticipantEvents fromName(String name) {
    switch (name) {
      case 'onWaitListParticipantAccepted':
        return RtkWaitlistedParticipantEvents.onWaitListParticipantAccepted;
      case 'onWaitListParticipantClosed':
        return RtkWaitlistedParticipantEvents.onWaitListParticipantClosed;
      case 'onWaitListParticipantJoined':
        return RtkWaitlistedParticipantEvents.onWaitListParticipantJoined;
      case 'onWaitListParticipantRejected':
        return RtkWaitlistedParticipantEvents.onWaitListParticipantRejected;
      default:
        return RtkWaitlistedParticipantEvents.unknown;
    }
  }
}
