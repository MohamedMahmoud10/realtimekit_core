import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';

abstract class RtkStage {
  List<RtkRemoteParticipant> get accessRequests =>
      RtkStageController.instance.accessRequests;

  StageStatus get status => RtkStageController.instance.stageStatus;

  void requestAccess() {}

  void cancelRequestAccess() {}

  void grantAccess(List<String> peerIds) {}

  void denyAccess(List<String> peerIds) {}

  void join() {}

  void leave() {}

  void kick(List<String> peerIds) {}
}
