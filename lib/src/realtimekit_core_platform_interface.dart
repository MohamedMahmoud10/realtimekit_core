import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';
import 'package:realtimekit_core_platform_interface/src/types/errors/rtk_error.dart';

/// The interface that implementations of rtk_core must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `FlutterCore`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added [RtkClientPlatform] methods.
abstract class RtkClientPlatform extends PlatformInterface {
  /// Constructs a FlutterCorePlatform.
  RtkClientPlatform() : super(token: _token);

  static final Object _token = Object();

  static RtkClientPlatform _instance = MethodChannelRtkClient();

  /// The default instance of [RtkClientPlatform] to use.
  ///
  /// Defaults to [MethodChannelRtkClient].
  static RtkClientPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [RtkClientPlatform] when they register themselves.
  static set instance(RtkClientPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  Future<void> init(RtkMeetingInfo rtkMeetingInfo,
      {VoidCallback? onSuccess, Function(RtkError?)? onError});

  void setSdkInfo(String? sdkName, String? version);

  RtkParticipants get participants;

  Stream<RtkParticipants> get participantsStream;

  Stream<List<RtkMeetingParticipant>> get activeStream;

  void closeParticipantsStream();

  SelfPermissions get permissions;

  Future<void> joinRoom(
      {VoidCallback? onSuccess, Function(RtkError?)? onError});

  Future<void> leaveRoom(
      {VoidCallback? onSuccess, Function(RtkError?)? onError});

  void addMeetingRoomEventListener(
      RtkMeetingRoomEventListener meetingRoomEventListener);
  void removeMeetingRoomEventListener(
      RtkMeetingRoomEventListener meetingRoomEventListener);
  Future<void> cleanNativeMeetingRoomEventListener();

  void addParticipantsEventListener(
      RtkParticipantsEventListener participantEventsListener);
  void removeParticipantsEventListener(
      RtkParticipantsEventListener participantEventsListener);
  Future<void> cleanNativeParticipantsEventListener();

  void addPluginsEventListener(RtkPluginsEventListener pluginsEventListener);
  void removePluginsEventListener(RtkPluginsEventListener pluginsEventListener);
  Future<void> cleanNativePluginsEventListener();

  void addSelfParticipantEventListener(RtkSelfEventListener selfEventListener);
  void removeSelfParticipantEventListener(
      RtkSelfEventListener selfEventListener);
  Future<void> cleanNativeSelfParticipantEventListener();

  void addChatEventListener(RtkChatEventListener chatEventListener);
  void removeChatEventListener(RtkChatEventListener chatEventListener);
  Future<void> cleanNativeChatListener();

  void addPollsEventListener(RtkPollsEventListener pollEventsListener);
  void removePollsEventListener(RtkPollsEventListener pollEventsListener);
  Future<void> cleanNativePollListener();

  void addDataUpdateEventListener(RtkDataEventListener listener);
  void removeDataUpdateEventListener(RtkDataEventListener listener);
  Future<void> cleanNativeDataUpdateListener();

  void addRecordingEventListener(RtkRecordingEventListener listener);
  void removeRecordingEventListener(RtkRecordingEventListener listener);
  Future<void> cleanNativeRecordingListener();

  void addWaitlistEventListener(RtkWaitlistEventListener listener);
  void removeWaitlistEventListener(RtkWaitlistEventListener listener);
  Future<void> cleanNativeWaitingRoomListener();

  void addLivestreamEventListener(RtkLivestreamEventListener listener);
  void removeLivestreamEventListener(RtkLivestreamEventListener listener);
  Future<void> cleanNativeLivestreamListener();

  void addStageEventListener(RtkStageEventListener listener);
  void removeStageEventListener(RtkStageEventListener listener);
  Future<void> cleanNativeStageEventListener();

  Future<void> enableCache();
  Future<void> disableCache();

  Future<void> cleanAllNativeListeners();

  Future<bool> release();

  Future<bool> launchUrl(String url);

  RtkMeta get meta;

  RtkSelfParticipant get localUser;

  RtkChat get chat;

  RtkPolls get polls;

  RtkPlugins get plugins;

  RtkRecording get recording;

  StageStatus get stageStatus;

  RtkLivestream get livestream;

  RtkStage get stage;
}
