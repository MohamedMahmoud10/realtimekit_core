enum RtkLivestreamEventsName {
  onLiveStreamStarting('onLiveStreamStarting'),
  onLiveStreamStarted('onLiveStreamStarted'),
  onLiveStreamStateUpdate('onLiveStreamStateUpdate'),
  onViewerCountUpdated('onViewerCountUpdated'),
  onLiveStreamEnding('onLiveStreamEnding'),
  onLiveStreamEnded('onLiveStreamEnded'),
  onLiveStreamErrored('onLiveStreamErrored'),
  onStageCountUpdated('onStageCountUpdated'),
  unknown('unknown');

  final String name;
  const RtkLivestreamEventsName(this.name);

  static RtkLivestreamEventsName fromName(String name) {
    switch (name) {
      case 'onLiveStreamStarting':
        return RtkLivestreamEventsName.onLiveStreamStarting;
      case 'onLiveStreamStarted':
        return RtkLivestreamEventsName.onLiveStreamStarted;
      case 'onLiveStreamStateUpdate':
        return RtkLivestreamEventsName.onLiveStreamStateUpdate;
      case 'onViewerCountUpdated':
        return RtkLivestreamEventsName.onViewerCountUpdated;
      case 'onLiveStreamEnding':
        return RtkLivestreamEventsName.onLiveStreamEnding;
      case 'onLiveStreamEnded':
        return RtkLivestreamEventsName.onLiveStreamEnded;
      case 'onLiveStreamErrored':
        return RtkLivestreamEventsName.onLiveStreamErrored;
      case 'onStageCountUpdated':
        return RtkLivestreamEventsName.onStageCountUpdated;
      default:
        return RtkLivestreamEventsName.unknown;
    }
  }
}
