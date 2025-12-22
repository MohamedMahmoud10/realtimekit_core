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
  /// [init] method is used to initialize the RealtimekitClient. It accepts [RtkMeetingInfo] as a parameter.
  /// optional [onSuccess] and [onError] parameters which are callbacks invoked in the success and error cases respectively.
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

  /// [joinRoom] method is used to join the room. It accepts two optional parameters [onSuccess] and [onError] which are callbacks invoked in the success and error cases respectively.
  void joinRoom({VoidCallback? onSuccess, Function(RtkError?)? onError}) =>
      _platform.joinRoom(onSuccess: onSuccess, onError: onError);

  /// [leaveRoom] method is used to leave the room. It accepts two optional parameters [onSuccess] and [onError] which are callbacks invoked in the success and error cases respectively.
  void leaveRoom({VoidCallback? onSuccess, Function(RtkError?)? onError}) =>
      _platform.leaveRoom(onSuccess: onSuccess, onError: onError);

  /// Used to get the participants of the room.
  RtkParticipants get participants => _platform.participants;

  /// Used to get the permissions of the current user.
  SelfPermissions get permissions => _platform.permissions;

  /// Used to get the active participants of the room.
  Stream<List<RtkMeetingParticipant>> get activeStream =>
      _platform.activeStream;

  /// Used to get the participants of the room.
  Stream<RtkParticipants> get participantsStream =>
      _platform.participantsStream.distinct();

  /// Used to close the participants stream.
  void closeParticipantsStream() => _platform.closeParticipantsStream();

  /// Used to add a meeting room event listener. It takes in [RtkMeetingRoomEventListener] as a parameter.
  void addMeetingRoomEventListener(
          RtkMeetingRoomEventListener meetingRoomEventListener) =>
      _platform.addMeetingRoomEventListener(meetingRoomEventListener);

  /// Used to remove a meeting room event listener. It takes in [RtkMeetingRoomEventListener] as a parameter.
  void removeMeetingRoomEventListener(
          RtkMeetingRoomEventListener meetingRoomEventListener) =>
      _platform.removeMeetingRoomEventListener(meetingRoomEventListener);

  Future<void> cleanNativeMeetingRoomEventListener() async {
    await _platform.cleanNativeMeetingRoomEventListener();
  }

  /// Used to add a participants event listener. It takes in [RtkParticipantsEventListener] as a parameter.
  void addParticipantsEventListener(
          RtkParticipantsEventListener participantsEventListener) =>
      _platform.addParticipantsEventListener(participantsEventListener);

  /// Used to remove a participants event listener. It takes in [RtkParticipantsEventListener] as a parameter.
  void removeParticipantsEventListener(
          RtkParticipantsEventListener participantsEventListener) =>
      _platform.removeParticipantsEventListener(participantsEventListener);

  Future<void> cleanNativeParticipantsEventListener() async {
    await _platform.cleanNativeParticipantsEventListener();
  }

  /// Used to add a self event listener. It takes in [RtkSelfEventListener] as a parameter.
  void addSelfEventListener(RtkSelfEventListener selfEventListener) =>
      _platform.addSelfParticipantEventListener(selfEventListener);

  /// Used to remove a self event listener. It takes in [RtkSelfEventListener] as a parameter.
  void removeSelfEventListener(RtkSelfEventListener selfEventListener) =>
      _platform.removeSelfParticipantEventListener(selfEventListener);

  Future<void> cleanNativeSelfParticipantEventListener() async {
    await _platform.cleanNativeSelfParticipantEventListener();
  }

  /// Used to add a plugins event listener. It takes in [RtkPluginsEventListener] as a parameter.
  void addPluginsEventListener(RtkPluginsEventListener pluginEventsListener) =>
      _platform.addPluginsEventListener(pluginEventsListener);

  /// Used to remove a plugins event listener. It takes in [RtkPluginsEventListener] as a parameter.
  void removePluginsEventListener(
          RtkPluginsEventListener pluginsEventListener) =>
      _platform.removePluginsEventListener(pluginsEventListener);

  Future<void> cleanNativePluginsEventListener() async {
    await _platform.cleanNativePluginsEventListener();
  }

  /// Used to add a recording event listener. It takes in [RtkRecordingEventListener] as a parameter.
  void addRecordingEventListener(
          RtkRecordingEventListener recordingEventListener) =>
      _platform.addRecordingEventListener(recordingEventListener);

  /// Used to remove a recording event listener. It takes in [RtkRecordingEventListener] as a parameter.
  void removeRecordingEventListener(
          RtkRecordingEventListener recordingEventListener) =>
      _platform.removeRecordingEventListener(recordingEventListener);

  Future<void> cleanNativeRecordingListener() async {
    await _platform.cleanNativeRecordingListener();
  }

  /// Used to add a chat event listener. It takes in [RtkChatEventListener] as a parameter.
  void addChatEventListener(RtkChatEventListener chatEventListener) =>
      _platform.addChatEventListener(chatEventListener);

  /// Used to remove a chat event listener. It takes in [RtkChatEventListener] as a parameter.
  void removeChatEventListener(RtkChatEventListener chatEventListener) =>
      _platform.removeChatEventListener(chatEventListener);

  Future<void> cleanNativeChatListener() async {
    await _platform.cleanNativeChatListener();
  }

  /// Used to add a data update event listener. It takes in [RtkDataEventListener] as a parameter.
  void addDataUpdateEventListener(
          RtkDataEventListener dataUpdateEventListener) =>
      _platform.addDataUpdateEventListener(dataUpdateEventListener);

  /// Used to remove a data update event listener. It takes in [RtkDataEventListener] as a parameter.
  void removeDataUpdateEventListener(
          RtkDataEventListener dataUpdateEventListener) =>
      _platform.removeDataUpdateEventListener(dataUpdateEventListener);

  Future<void> cleanNativeDataUpdateListener() async {
    await _platform.cleanNativeDataUpdateListener();
  }

  /// Used to add a waitlist event listener. It takes in [RtkWaitlistEventListener] as a parameter.
  void addWaitlistEventListener(
          RtkWaitlistEventListener waitlistEventListener) =>
      _platform.addWaitlistEventListener(waitlistEventListener);

  /// Used to remove a waitlist event listener. It takes in [RtkWaitlistEventListener] as a parameter.
  void removeWaitlistEventListener(
          RtkWaitlistEventListener waitlistEventListener) =>
      _platform.removeWaitlistEventListener(waitlistEventListener);

  Future<void> cleanNativeWaitingRoomListener() async {
    await _platform.cleanNativeWaitingRoomListener();
  }

  /// Used to add a polls event listener. It takes in [RtkPollsEventListener] as a parameter.
  void addPollsEventListener(RtkPollsEventListener pollsEventListener) =>
      _platform.addPollsEventListener(pollsEventListener);

  /// Used to remove a polls event listener. It takes in [RtkPollsEventListener] as a parameter.
  void removePollsEventListener(RtkPollsEventListener pollsEventListener) =>
      _platform.removePollsEventListener(pollsEventListener);

  Future<void> cleanNativePollListener() async {
    await _platform.cleanNativePollListener();
  }

  /// Used to add a livestream event listener. It takes in [RtkLivestreamEventListener] as a parameter.
  void addLivestreamEventListener(
          RtkLivestreamEventListener livestreamEventListener) =>
      _platform.addLivestreamEventListener(livestreamEventListener);

  /// Used to remove a livestream event listener. It takes in [RtkLivestreamEventListener] as a parameter.
  void removeLivestreamEventListener(
          RtkLivestreamEventListener livestreamEventListener) =>
      _platform.removeLivestreamEventListener(livestreamEventListener);

  Future<void> cleanNativeLivestreamListener() async {
    await _platform.cleanNativeLivestreamListener();
  }

  /// Used to add a stage event listener. It takes in [RtkStageEventListener] as a parameter.
  void addStageEventListener(RtkStageEventListener stageEventListener) =>
      _platform.addStageEventListener(stageEventListener);

  /// Used to remove a stage event listener. It takes in [RtkStageEventListener] as a parameter.
  void removeStageEventListener(RtkStageEventListener stageEventListener) =>
      _platform.removeStageEventListener(stageEventListener);

  Future<void> cleanNativeStageEventListener() async {
    await _platform.cleanNativeStageEventListener();
  }

  /// Used to clean all native listeners. Always call this method at the last of your app lifecycle after you have unregistered realtimekit related flutter side listeners.
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
