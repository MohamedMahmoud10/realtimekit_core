import '../../../realtimekit_ui.dart';

abstract class RtkLivestreamState {}

class OnLivestreamInitial extends RtkLivestreamState {}

class OnLivestreamStarting extends RtkLivestreamState {}

class OnLivestreamStarted extends RtkLivestreamState {}

class OnLivestreamEnding extends RtkLivestreamState {}

class OnLivestreamEnded extends RtkLivestreamState {}

class OnLivestreamErrored extends RtkLivestreamState {}

class OnLivestreamStateUpdate extends RtkLivestreamState {
  final RtkLivestreamData data;
  OnLivestreamStateUpdate(this.data);
}

class OnLvsStageCountUpdate extends RtkLivestreamState {
  final int count;
  OnLvsStageCountUpdate(this.count);
}

class OnLvsViewerCountUpdated extends RtkLivestreamState {}
