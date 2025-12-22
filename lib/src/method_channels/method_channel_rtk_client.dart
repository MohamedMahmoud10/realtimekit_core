import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';
import 'package:realtimekit_core_platform_interface/src/types/errors/rtk_error.dart';

/// An implementation of [RtkClientPlatform] that uses method channels.
class MethodChannelRtkClient extends RtkClientPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('realtimekit_core');

  static const participantEventMethodChannel =
      MethodChannel('realtimekit_core_participants');
  static const roomEventChannel = MethodChannel('realtimekit_core_room');

  @override
  void addMeetingRoomEventListener(
      RtkMeetingRoomEventListener meetingRoomEventListener) async {}

  @override
  RtkParticipants get participants => throw UnimplementedError();

  @override
  void addParticipantsEventListener(
      RtkParticipantsEventListener participantEventsListener) async {}

  @override
  void addSelfParticipantEventListener(RtkSelfEventListener listener) async {}

  @override
  Stream<RtkParticipants> get participantsStream => throw UnimplementedError();

  @override
  RtkSelfParticipant get localUser => throw UnimplementedError();

  @override
  RtkChat get chat => throw UnimplementedError();

  @override
  void closeParticipantsStream() {}

  @override
  RtkPolls get polls => throw UnimplementedError();

  @override
  Stream<List<RtkMeetingParticipant>> get activeStream =>
      throw UnimplementedError();

  @override
  RtkRecording get recording => throw UnimplementedError();

  @override
  void addPluginsEventListener(RtkPluginsEventListener pluginsEventsListener) {
    throw UnimplementedError();
  }

  @override
  RtkPlugins get plugins => throw UnimplementedError();

  @override
  RtkMeta get meta => throw UnimplementedError();

  @override
  SelfPermissions get permissions => throw UnimplementedError();

  @override
  void addChatEventListener(RtkChatEventListener chatEventListener) {
    throw UnimplementedError();
  }

  @override
  void addPollsEventListener(RtkPollsEventListener pollEventsListener) {
    throw UnimplementedError();
  }

  @override
  void addDataUpdateEventListener(RtkDataEventListener listener) {
    throw UnimplementedError();
  }

  @override
  void removeDataUpdateEventListener(RtkDataEventListener listener) async {}

  @override
  void removeChatEventListener(RtkChatEventListener chatEventListener) async {}

  @override
  void removeMeetingRoomEventListener(
      RtkMeetingRoomEventListener meetingRoomEventListener) async {}

  @override
  void removeParticipantsEventListener(
      RtkParticipantsEventListener participantEventsListener) async {}

  @override
  void removePluginsEventListener(
      RtkPluginsEventListener pluginEventsListener) async {}

  @override
  void removePollsEventListener(
      RtkPollsEventListener pollEventsListener) async {}

  @override
  void removeSelfParticipantEventListener(
      RtkSelfEventListener listener) async {}

  @override
  void addRecordingEventListener(RtkRecordingEventListener listener) async {}

  @override
  void removeRecordingEventListener(RtkRecordingEventListener listener) async {}

  @override
  void addWaitlistEventListener(RtkWaitlistEventListener listener) async {}

  @override
  void removeWaitlistEventListener(RtkWaitlistEventListener listener) async {}

  @override
  void addLivestreamEventListener(RtkLivestreamEventListener listener) async {}

  @override
  void removeLivestreamEventListener(
      RtkLivestreamEventListener listener) async {}

  @override
  get livestream => throw UnimplementedError();

  @override
  StageStatus get stageStatus => throw UnimplementedError();

  @override
  void addStageEventListener(RtkStageEventListener listener) async {}

  @override
  void removeStageEventListener(RtkStageEventListener listener) async {}

  @override
  RtkStage get stage => throw UnimplementedError();

  @override
  Future<void> disableCache() async {}

  @override
  Future<void> enableCache() async {}

  @override
  Future<bool> launchUrl(String url) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> release() async {
    throw UnimplementedError();
  }

  @override
  Future<void> cleanAllNativeListeners() {
    throw UnimplementedError();
  }

  @override
  Future<void> cleanNativeChatListener() {
    throw UnimplementedError();
  }

  @override
  Future<void> cleanNativeLivestreamListener() {
    throw UnimplementedError();
  }

  @override
  Future<void> cleanNativeMeetingRoomEventListener() {
    throw UnimplementedError();
  }

  @override
  Future<void> cleanNativeParticipantsEventListener() {
    throw UnimplementedError();
  }

  @override
  Future<void> cleanNativePluginsEventListener() {
    throw UnimplementedError();
  }

  @override
  Future<void> cleanNativePollListener() {
    throw UnimplementedError();
  }

  @override
  Future<void> cleanNativeSelfParticipantEventListener() {
    throw UnimplementedError();
  }

  @override
  Future<void> cleanNativeWaitingRoomListener() {
    throw UnimplementedError();
  }

  @override
  void setSdkInfo(String? sdkName, String? version) {
    throw UnimplementedError();
  }

  @override
  Future<void> cleanNativeDataUpdateListener() {
    // TODO: implement cleanNativeDataUpdateListener
    throw UnimplementedError();
  }

  @override
  Future<void> cleanNativeRecordingListener() {
    // TODO: implement cleanNativeRecordingListener
    throw UnimplementedError();
  }

  @override
  Future<void> cleanNativeStageEventListener() {
    // TODO: implement cleanNativeStageEventListener
    throw UnimplementedError();
  }

  @override
  Future<void> init(RtkMeetingInfo rtkMeetingInfo,
      {VoidCallback? onSuccess, Function(RtkError? p1)? onError}) {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  Future<void> joinRoom(
      {VoidCallback? onSuccess, Function(RtkError? p1)? onError}) {
    // TODO: implement joinRoom
    throw UnimplementedError();
  }

  @override
  Future<void> leaveRoom(
      {VoidCallback? onSuccess, Function(RtkError? p1)? onError}) {
    // TODO: implement leaveRoom
    throw UnimplementedError();
  }
}
