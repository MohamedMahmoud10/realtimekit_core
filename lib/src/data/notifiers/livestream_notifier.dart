import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/data/states/livestream_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LvsStateNotifier extends Notifier<RtkLivestreamState>
    implements RtkLivestreamEventListener {
  @override
  RtkLivestreamState build() {
    return OnLivestreamInitial();
  }

  @override
  void onLiveStreamStarting() {
    state = OnLivestreamStarting();
  }

  @override
  void onLiveStreamStarted() {
    state = OnLivestreamStarted();
  }

  @override
  void onLiveStreamEnding() {
    state = OnLivestreamEnding();
  }

  @override
  void onLiveStreamEnded() {
    state = OnLivestreamEnded();
  }

  @override
  void onLiveStreamErrored() {
    state = OnLivestreamEnded();
  }

  @override
  void onLiveStreamStateUpdate(RtkLivestreamData data) {
    state = OnLivestreamStateUpdate(data);
  }

  @override
  void onStageCountUpdated(int count) {
    state = OnLvsStageCountUpdate(count);
  }

  @override
  void onViewerCountUpdated(int count) {
    state = OnLvsViewerCountUpdated();
  }
}
