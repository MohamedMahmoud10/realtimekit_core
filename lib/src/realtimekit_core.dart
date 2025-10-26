import 'dart:convert';
import 'dart:developer';

import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

RtkClientPlatform get _platform => RtkClientPlatform.instance;

class RtkBase64Encoding {
  static String auth({required String organizationId, required String apiKey}) {
    final decodedString = '${organizationId.trim()}:${apiKey.trim()}';
    final bytes = utf8.encode(decodedString);

    final base64Enc = base64.encode(bytes);
    return 'Basic $base64Enc';
  }
}

class RealtimekitClient {
  void init(RtkMeetingInfo meetingInfo,
      {VoidCallback? onSuccess, Function(RtkError?)? onError}) async {
    await _platform.init(meetingInfo);

    try {
      final yamlFile = await rootBundle.loadString(
        "packages/realtimekit_core/pubspec.yaml",
      );

      final pubspec = Pubspec.parse(yamlFile);
      setSdkInfo(pubspec.name, pubspec.version?.canonicalizedVersion ?? '');
    } catch (e) {
      log("ERROR: No pubspec.yaml file found!");
    }
  }

  void joinRoom({VoidCallback? onSuccess, Function(RtkError?)? onError}) =>
      _platform.joinRoom(onSuccess: onSuccess, onError: onError);

  void leaveRoom({VoidCallback? onSuccess, Function(RtkError?)? onError}) =>
      _platform.leaveRoom(onSuccess: onSuccess, onError: onError);

  RtkParticipants get participants => _platform.participants;

  SelfPermissions get permissions => _platform.permissions;

  Stream<List<RtkMeetingParticipant>> get activeStream =>
      _platform.activeStream;

  Stream<RtkParticipants> get participantsStream =>
      _platform.participantsStream.distinct();

  void closeParticipantsStream() => _platform.closeParticipantsStream();

  void addMeetingRoomEventListener(
          RtkMeetingRoomEventListener meetingRoomEventListener) =>
      _platform.addMeetingRoomEventListener(meetingRoomEventListener);

  void removeMeetingRoomEventListener(
          RtkMeetingRoomEventListener meetingRoomEventListener) =>
      _platform.removeMeetingRoomEventListener(meetingRoomEventListener);

  Future<void> cleanNativeMeetingRoomEventListener() async {
    await _platform.cleanNativeMeetingRoomEventListener();
  }

  void addParticipantsEventListener(
          RtkParticipantsEventListener participantsEventListener) =>
      _platform.addParticipantsEventListener(participantsEventListener);

  void removeParticipantsEventListener(
          RtkParticipantsEventListener participantsEventListener) =>
      _platform.removeParticipantsEventListener(participantsEventListener);

  Future<void> cleanNativeParticipantsEventListener() async {
    await _platform.cleanNativeParticipantsEventListener();
  }

  void addSelfEventListener(RtkSelfEventListener selfEventListener) =>
      _platform.addSelfParticipantEventListener(selfEventListener);

  void removeSelfEventListener(RtkSelfEventListener selfEventListener) =>
      _platform.removeSelfParticipantEventListener(selfEventListener);

  Future<void> cleanNativeSelfParticipantEventListener() async {
    await _platform.cleanNativeSelfParticipantEventListener();
  }

  void addPluginsEventListener(RtkPluginsEventListener pluginEventsListener) =>
      _platform.addPluginsEventListener(pluginEventsListener);

  void removePluginsEventListener(
          RtkPluginsEventListener pluginsEventListener) =>
      _platform.removePluginsEventListener(pluginsEventListener);

  Future<void> cleanNativePluginsEventListener() async {
    await _platform.cleanNativePluginsEventListener();
  }

  void addRecordingEventListener(
          RtkRecordingEventListener recordingEventListener) =>
      _platform.addRecordingEventListener(recordingEventListener);

  void removeRecordingEventListener(
          RtkRecordingEventListener recordingEventListener) =>
      _platform.removeRecordingEventListener(recordingEventListener);

  Future<void> cleanNativeRecordingListener() async {
    await _platform.cleanNativeRecordingListener();
  }

  void addChatEventListener(RtkChatEventListener chatEventListener) =>
      _platform.addChatEventListener(chatEventListener);

  void removeChatEventListener(RtkChatEventListener chatEventListener) =>
      _platform.removeChatEventListener(chatEventListener);

  Future<void> cleanNativeChatListener() async {
    await _platform.cleanNativeChatListener();
  }

  void addDataUpdateEventListener(
          RtkDataEventListener dataUpdateEventListener) =>
      _platform.addDataUpdateEventListener(dataUpdateEventListener);

  void removeDataUpdateEventListener(
          RtkDataEventListener dataUpdateEventListener) =>
      _platform.removeDataUpdateEventListener(dataUpdateEventListener);

  Future<void> cleanNativeDataUpdateListener() async {
    await _platform.cleanNativeDataUpdateListener();
  }

  void addWaitlistEventListener(
          RtkWaitlistEventListener waitlistEventListener) =>
      _platform.addWaitlistEventListener(waitlistEventListener);

  void removeWaitlistEventListener(
          RtkWaitlistEventListener waitlistEventListener) =>
      _platform.removeWaitlistEventListener(waitlistEventListener);

  Future<void> cleanNativeWaitingRoomListener() async {
    await _platform.cleanNativeWaitingRoomListener();
  }

  void addPollsEventListener(RtkPollsEventListener pollsEventListener) =>
      _platform.addPollsEventListener(pollsEventListener);

  void removePollsEventListener(RtkPollsEventListener pollsEventListener) =>
      _platform.removePollsEventListener(pollsEventListener);

  Future<void> cleanNativePollListener() async {
    await _platform.cleanNativePollListener();
  }

  void addLivestreamEventListener(
          RtkLivestreamEventListener livestreamEventListener) =>
      _platform.addLivestreamEventListener(livestreamEventListener);

  void removeLivestreamEventListener(
          RtkLivestreamEventListener livestreamEventListener) =>
      _platform.removeLivestreamEventListener(livestreamEventListener);

  Future<void> cleanNativeLivestreamListener() async {
    await _platform.cleanNativeLivestreamListener();
  }

  void addStageEventListener(RtkStageEventListener stageEventListener) =>
      _platform.addStageEventListener(stageEventListener);

  void removeStageEventListener(RtkStageEventListener stageEventListener) =>
      _platform.removeStageEventListener(stageEventListener);

  Future<void> cleanNativeStageEventListener() async {
    await _platform.cleanNativeStageEventListener();
  }

  void cleanAllNativeListeners() {
    _platform.cleanAllNativeListeners();
  }

  void setSdkInfo(String sdkName, String version) {
    _platform.setSdkInfo(sdkName, version);
  }

  Future<void> disableCache() async => await _platform.disableCache();

  Future<void> enableCache() async => await _platform.enableCache();

  void launchUrl(String url) => _platform.launchUrl(url);

  Future<bool> release() async => await _platform.release();

  RtkMeta get meta => _platform.meta;

  RtkSelfParticipant get localUser => _platform.localUser;

  RtkRecording get recording => _platform.recording;

  RtkPolls get polls => _platform.polls;

  RtkChat get chat => _platform.chat;

  RtkPlugins get plugins => _platform.plugins;

  RtkLivestream get livestream => _platform.livestream;

  RtkStage get stage => _platform.stage;
}
