import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';

const _coreMethodChannel = MethodChannel('realtimekit_core_android');

final _localUserApi = _LocalUserApiAndroidImpl(_coreMethodChannel);

const roomEventChannel =
    EventChannel('com.cloudflare.realtimekit/meetingRoomEvents');
const chatEventChannel = EventChannel('com.cloudflare.realtimekit/chats');
const participantEventChannel =
    EventChannel('com.cloudflare.realtimekit/participants');
const selfListenerChannel = EventChannel("com.cloudflare.realtimekit/self");
const pollsListenerChannel = EventChannel("com.cloudflare.realtimekit/polls");
const pluginsListenerChannel =
    EventChannel("com.cloudflare.realtimekit/plugins");
const dataListenerChannel = EventChannel("com.cloudflare.realtimekit/data");
const recordingListenerChannel =
    EventChannel("com.cloudflare.realtimekit/recording");
const waitingRoomListenerChannel =
    EventChannel("com.cloudflare.realtimekit/waitlist");
const livestreamListenerChannel =
    EventChannel("com.cloudflare.realtimekit/livestream");
const stageEventsListenerChannel =
    EventChannel("com.cloudflare.realtimekit/stage");

final RtkJoinedMeetingParticipantApi joinedMeetingParticipantApi =
    _RtkJoinedMeetingParticipantApiImpl();

final RtkMeetingParticipantApi meetingParticipantApi =
    _RtkMeetingParticipantApiImpl();

final _pluginApi = _RtkPluginApi();

final waitlistedApi = _WaitlistingApi();

final _participantsApi = _RtkParticipantsApiImpl();

final _pluginsController = RtkPluginsController.instance;

class _RtkParticipantsApiImpl implements RtkParticipantsApi {
  @override
  void setPage(int pageNumber) {
    _coreMethodChannel.invokeMethod('setPage', pageNumber);
  }

  @override
  void disableAllAudio({OnResult? onResult}) {
    _coreMethodChannel.invokeMethod('disableAllAudio').then((value) {
      if (value == null && onResult != null) {
        onResult(null);
        return;
      }
      if (value != null && onResult != null) {
        final error = HostErrorUtils.fromErrorCode(errorCode: value);
        onResult(error);
      }
    });
  }

  @override
  void disableAllVideo({OnResult? onResult}) {
    _coreMethodChannel.invokeMethod('disableAllVideo').then((value) {
      if (value == null && onResult != null) {
        onResult(null);
        return;
      }
      if (value != null && onResult != null) {
        final error = HostErrorUtils.fromErrorCode(errorCode: value);
        onResult(error);
      }
    });
  }

  @override
  void kickAll({OnResult? onResult}) {
    _coreMethodChannel.invokeMethod('kickAll').then((value) {
      if (value == null && onResult != null) {
        onResult(null);
        return;
      }
      if (value != null && onResult != null) {
        final error = HostErrorUtils.fromErrorCode(errorCode: value);
        onResult(error);
      }
    });
  }

  @override
  void acceptWaitlistedParticipant(
      RtkMeetingParticipant waitlistingParticipant) {
    _coreMethodChannel.invokeMethod(
        "acceptWaitListedRequest", waitlistingParticipant.id);
  }

  @override
  void rejectWaitlistedParticipant(
      RtkMeetingParticipant waitlistingParticipant) {
    _coreMethodChannel.invokeMethod(
        "rejectWaitListedRequest", waitlistingParticipant.id);
  }

  @override
  void broadcastMessage(String type, Map<String, dynamic> payload) {
    _coreMethodChannel
        .invokeMethod("broadcastMessage", {"type": type, "payload": payload});
  }

  @override
  void acceptAllWaitingRoomRequests() {
    _coreMethodChannel.invokeMethod("acceptAllWaitingRoomRequests");
  }
}

class OnMeetingInitCompletedCallback extends RtkMeetingRoomEventListener {
  final VoidCallback onMeetingInitCompletedCall;
  OnMeetingInitCompletedCallback(this.onMeetingInitCompletedCall);
  @override
  void onMeetingInitCompleted() => onMeetingInitCompletedCall.call();
}

/// The Android implementation of [RtkClientPlatform].
class FlutterCoreAndroid extends RtkClientPlatform {
  /// Registers this class as the default instance of [RtkClientPlatform]

  final _participantListenerChannel = RtkParticipantEventsListenerChannel(
    participantEventChannel,
    joinedMeetingParticipantApi,
    meetingParticipantApi,
    waitlistedApi,
    _localUserApi,
    _participantsApi,
  );

  final _selfListenerChannel = RtkSelfListenerChannel(
    selfListenerChannel,
    _localUserApi,
    joinedMeetingParticipantApi,
    meetingParticipantApi,
  );

  final _roomEventListener =
      RtkMeetingRoomEventListenerChannel(roomEventChannel);

  final _chatListener = RtkChatListenerChannel(chatEventChannel);

  final _pollListener = RtkPollListenerChannel(pollsListenerChannel);

  final _pluginListener =
      RtkPluginsListenerChannel(pluginsListenerChannel, _pluginApi);

  final _dataListener = RtkDataListenerChannel(
    waitlistedApi,
    dataListenerChannel,
    _pluginApi,
    joinedMeetingParticipantApi,
    meetingParticipantApi,
  );

  final _recordingListener =
      RtkRecordingListenerChannel(recordingListenerChannel);
  final _waitingRoomListener = RtkWaitingRoomListenerChannel(
    joinedMeetingParticipantApi,
    waitingRoomListenerChannel,
    waitlistedApi,
    meetingParticipantApi,
  );

  final _livestreamListener =
      RtkLivestreamListenerChannel(livestreamListenerChannel);

  final _stageListener = RtkStageListenerChannel(
    stageEventsListenerChannel,
    joinedMeetingParticipantApi,
    meetingParticipantApi,
    waitlistedApi,
  );

  final RtkParticipantController _participantController =
      RtkParticipantController.instance;

  final RtkChatController _chatController = RtkChatController.instance;

  final RtkPollController _pollController = RtkPollController.instance;

  final RtkDataController _dataController = RtkDataController.instance;

  final RtkLivestreamController _livestreamController =
      RtkLivestreamController.instance;

  final RtkRecordingController _recordingController =
      RtkRecordingController.instance;

  final RtkStageController _stageController = RtkStageController.instance;

  static void registerWith() {
    RtkClientPlatform.instance = FlutterCoreAndroid();
  }

  final LocalUserController _localUserController = LocalUserController(
    _localUserApi,
    meetingParticipantApi,
  );

  Future<bool> initializeXListener<T extends RtkListener>(
    bool nativeListenerAttached,
    RtkListenerChannel listener,
  ) async {
    if (!nativeListenerAttached) {
      try {
        await listener.init(_coreMethodChannel);
      } catch (e) {
        return false;
      }
      return true;
    } else {
      return nativeListenerAttached;
    }
  }

  void attachListener<T extends RtkListener>(
    T? nativeController,
    void Function(T listener) onNativeListenerAttached,
    List<T> cachedListeners,
  ) {
    if (nativeController != null) {
      onNativeListenerAttached.call(nativeController);
    }
    for (final listener in cachedListeners) {
      onNativeListenerAttached(listener);
    }
    cachedListeners.clear();
  }

  @override
  Future<void> init(
    RtkMeetingInfo rtkMeetingInfo, {
    VoidCallback? onSuccess,
    Function(RtkError?)? onError,
  }) async {
    // await _coreMethodChannel.invokeMethod('addMeetingRoomEventsListener');

    // This sequence is important because _chatController uses EventChannel and it
    // sets up EventChannel to start listening for incoming events, and then once we
    // invoke "addChatListener", on Kotlin side the event sink is not null.
    _isChatNativeListenerAttached =
        await initializeXListener<RtkChatEventListener>(
      _isChatNativeListenerAttached,
      _chatListener,
    );
    attachListener<RtkChatEventListener>(
      _chatController,
      addChatEventListener,
      _addAfterChatListenerAttached,
    );

    _isParticipantNativeListenerAttached =
        await initializeXListener<RtkParticipantsEventListener>(
      _isParticipantNativeListenerAttached,
      _participantListenerChannel,
    );
    attachListener<RtkParticipantsEventListener>(
      _participantController,
      addParticipantsEventListener,
      _addAfterParticipantListenerAttached,
    );

    _isSelfNativeListenerAttached =
        await initializeXListener<RtkSelfEventListener>(
      _isSelfNativeListenerAttached,
      _selfListenerChannel,
    );

    attachListener<RtkSelfEventListener>(
      _localUserController,
      addSelfParticipantEventListener,
      _addAfterSelfListenerAttached,
    );

    _isRecordingNativeListenerAttached =
        await initializeXListener<RtkRecordingEventListener>(
      _isRecordingNativeListenerAttached,
      _recordingListener,
    );

    attachListener<RtkRecordingEventListener>(
      _recordingController,
      addRecordingEventListener,
      _addAfterRecordingListenerAttached,
    );

    // addRecordingListener(_recordingController);
    // await _coreMethodChannel.invokeMethod('addRecordingEventsListener');

    _isPollNativeListenerAttached =
        await initializeXListener<RtkPollsEventListener>(
      _isPollNativeListenerAttached,
      _pollListener,
    );
    attachListener<RtkPollsEventListener>(
      _pollController,
      addPollsEventListener,
      _addAfterPollListenerAttached,
    );
    // addPollListener(_pollController);
    // await _coreMethodChannel.invokeMethod('addPollsEventsListener');

    _isDataNativeListenerAttached =
        await initializeXListener<RtkDataEventListener>(
      _isDataNativeListenerAttached,
      _dataListener,
    );
    attachListener<RtkDataEventListener>(
      _dataController,
      addDataUpdateEventListener,
      _addAfterDataListenerAttached,
    );

    _isStageNativeListenerAttached =
        await initializeXListener<RtkStageEventListener>(
      _isStageNativeListenerAttached,
      _stageListener,
    );
    attachListener<RtkStageEventListener>(
      _stageController,
      addStageEventListener,
      _addAfterStageListenerAttached,
    );

    _isLvsNativeListenerAttached =
        await initializeXListener<RtkLivestreamEventListener>(
      _isLvsNativeListenerAttached,
      _livestreamListener,
    );
    attachListener<RtkLivestreamEventListener>(
      _livestreamController,
      addLivestreamEventListener,
      _addAfterLvsListenerAttached,
    );

    _isPluginNativeListenerAttached =
        await initializeXListener<RtkPluginsEventListener>(
      _isPluginNativeListenerAttached,
      _pluginListener,
    );
    attachListener<RtkPluginsEventListener>(
      null,
      addPluginsEventListener,
      _addAfterPluginListenerAttached,
    );

    attachListener<RtkPluginsEventListener>(
      _pluginsController,
      addPluginsEventListener,
      _addAfterPluginListenerAttached,
    );

    _isWaitingNativeListenerAttached =
        await initializeXListener<RtkWaitlistEventListener>(
      _isWaitingNativeListenerAttached,
      _waitingRoomListener,
    );
    attachListener<RtkWaitlistEventListener>(
      null,
      addWaitlistEventListener,
      _addAfterWaitingListenerAttached,
    );

    _isRoomNativeListenerAttached =
        await initializeXListener<RtkMeetingRoomEventListener>(
      _isRoomNativeListenerAttached,
      _roomEventListener,
    );
    attachListener<RtkMeetingRoomEventListener>(
      null,
      addMeetingRoomEventListener,
      _addAfterRoomListenerAttached,
    );

    final error =
        await _coreMethodChannel.invokeMethod('init', rtkMeetingInfo.toMap());
    if (error == null) {
      onSuccess?.call();
    } else {
      final meetingError = MeetingErrorUtils.fromErrorCode(errorCode: error);
      if (onError != null) {
        onError(meetingError);
      }
    }
  }

  @override
  Future<void> joinRoom({
    VoidCallback? onSuccess,
    Function(RtkError?)? onError,
  }) async {
    final error = await _coreMethodChannel.invokeMethod('joinRoom');
    if (error == null) {
      onSuccess?.call();
    } else {
      final meetingError = MeetingErrorUtils.fromErrorCode(errorCode: error);
      if (onError != null) {
        onError(meetingError);
      }
    }
  }

  @override
  Future<void> leaveRoom({
    VoidCallback? onSuccess,
    Function(RtkError?)? onError,
  }) async {
    final error = await _coreMethodChannel.invokeMethod('leaveRoom');
    if (error == null) {
      onSuccess?.call();
    } else {
      final meetingError = MeetingErrorUtils.fromErrorCode(errorCode: error);
      if (onError != null) {
        onError(meetingError);
      }
    }
  }

  @override
  RtkParticipants get participants =>
      _participantController.currentParticipants;

  bool _isRoomNativeListenerAttached = false;
  final List<RtkMeetingRoomEventListener> _addAfterRoomListenerAttached = [];

  @override
  void addMeetingRoomEventListener(
      RtkMeetingRoomEventListener meetingRoomEventListener) {
    _isRoomNativeListenerAttached
        ? _roomEventListener.attach(meetingRoomEventListener)
        : _addAfterRoomListenerAttached.add(meetingRoomEventListener);
  }

  @override
  void removeMeetingRoomEventListener(
      RtkMeetingRoomEventListener meetingRoomEventListener) {
    return _roomEventListener.detach(meetingRoomEventListener);
  }

  bool _isParticipantNativeListenerAttached = false;
  final List<RtkParticipantsEventListener>
      _addAfterParticipantListenerAttached = [];

  @override
  void addParticipantsEventListener(
      RtkParticipantsEventListener participantsEventListener) {
    _isParticipantNativeListenerAttached
        ? _participantListenerChannel.attach(participantsEventListener)
        : _addAfterParticipantListenerAttached.add(participantsEventListener);
  }

  @override
  void removeParticipantsEventListener(
      RtkParticipantsEventListener participantEventsListener) {
    return _participantListenerChannel.detach(participantEventsListener);
  }

  bool _isPluginNativeListenerAttached = false;
  final List<RtkPluginsEventListener> _addAfterPluginListenerAttached = [];

  @override
  Future<void> addPluginsEventListener(
      RtkPluginsEventListener pluginsEventListener) async {
    _isPluginNativeListenerAttached
        ? _pluginListener.attach(pluginsEventListener)
        : _addAfterPluginListenerAttached.add(pluginsEventListener);
  }

  @override
  void removePluginsEventListener(
      RtkPluginsEventListener pluginsEventListener) {
    return _pluginListener.detach(pluginsEventListener);
  }

  bool _isChatNativeListenerAttached = false;
  final List<RtkChatEventListener> _addAfterChatListenerAttached = [];

  @override
  void addChatEventListener(RtkChatEventListener chatEventListener) {
    _isChatNativeListenerAttached
        ? _chatListener.attach(chatEventListener)
        : _addAfterChatListenerAttached.add(chatEventListener);
  }

  @override
  void removeChatEventListener(RtkChatEventListener chatEventListener) {
    _chatListener.detach(chatEventListener);
  }

  bool _isPollNativeListenerAttached = false;
  final List<RtkPollsEventListener> _addAfterPollListenerAttached = [];

  @override
  void addPollsEventListener(RtkPollsEventListener pollEventsListener) {
    _isPollNativeListenerAttached
        ? _pollListener.attach(pollEventsListener)
        : _addAfterPollListenerAttached.add(pollEventsListener);
  }

  @override
  void removePollsEventListener(RtkPollsEventListener pollsEventListener) {
    return _pollListener.detach(pollsEventListener);
  }

  bool _isDataNativeListenerAttached = false;
  final List<RtkDataEventListener> _addAfterDataListenerAttached = [];

  @override
  void addDataUpdateEventListener(RtkDataEventListener listener) {
    _isDataNativeListenerAttached
        ? _dataListener.attach(listener)
        : _addAfterDataListenerAttached.add(listener);
  }

  @override
  void removeDataUpdateEventListener(RtkDataEventListener listener) {
    return _dataListener.detach(listener);
  }

  bool _isSelfNativeListenerAttached = false;
  final List<RtkSelfEventListener> _addAfterSelfListenerAttached = [];

  @override
  void addSelfParticipantEventListener(RtkSelfEventListener listener) {
    _isSelfNativeListenerAttached
        ? _selfListenerChannel.attach(listener)
        : _addAfterSelfListenerAttached.add(listener);
  }

  @override
  void removeSelfParticipantEventListener(RtkSelfEventListener listener) {
    return _selfListenerChannel.detach(listener);
  }

  bool _isRecordingNativeListenerAttached = false;
  final List<RtkRecordingEventListener> _addAfterRecordingListenerAttached = [];

  @override
  void addRecordingEventListener(RtkRecordingEventListener listener) {
    _isRecordingNativeListenerAttached
        ? _recordingListener.attach(listener)
        : _addAfterRecordingListenerAttached.add(listener);
  }

  @override
  void removeRecordingEventListener(RtkRecordingEventListener listener) {
    return _recordingListener.detach(listener);
  }

  bool _isWaitingNativeListenerAttached = false;
  final List<RtkWaitlistEventListener> _addAfterWaitingListenerAttached = [];
  @override
  void addWaitlistEventListener(RtkWaitlistEventListener listener) {
    _isWaitingNativeListenerAttached
        ? _waitingRoomListener.attach(listener)
        : _addAfterWaitingListenerAttached.add(listener);
  }

  @override
  void removeWaitlistEventListener(RtkWaitlistEventListener listener) {
    return _waitingRoomListener.detach(listener);
  }

  bool _isStageNativeListenerAttached = false;
  final List<RtkStageEventListener> _addAfterStageListenerAttached = [];

  @override
  void addStageEventListener(RtkStageEventListener listener) {
    _isStageNativeListenerAttached
        ? _stageListener.attach(listener)
        : _addAfterStageListenerAttached.add(listener);
  }

  @override
  void removeStageEventListener(RtkStageEventListener listener) {
    return _stageListener.detach(listener);
  }

  @override
  Stream<RtkParticipants> get participantsStream =>
      _participantController.participantStream;

  @override
  RtkSelfParticipant get localUser => _localUserController.localUser;

  @override
  RtkChat get chat => _RtkChatImpl();

  @override
  void closeParticipantsStream() =>
      _participantController.closeParticipantStream();

  @override
  RtkPolls get polls => _RtkPollImpl();

  @override
  Stream<List<RtkMeetingParticipant>> get activeStream =>
      _participantController.activeStream;

  @override
  RtkRecording get recording => _RtkRecordingImpl();

  @override
  RtkPlugins get plugins =>
      _RtkPluginsImpl(_dataController, _pluginsController);

  @override
  RtkMeta get meta => _dataController.meta;

  @override
  SelfPermissions get permissions => _dataController.permissions;

  bool _isLvsNativeListenerAttached = false;
  set isLvsNativeListenerAttached(bool value) =>
      _isLvsNativeListenerAttached = value;
  final List<RtkLivestreamEventListener> _addAfterLvsListenerAttached = [];

  @override
  void addLivestreamEventListener(RtkLivestreamEventListener listener) {
    _isLvsNativeListenerAttached
        ? _livestreamListener.attach(listener)
        : _addAfterLvsListenerAttached.add(listener);
  }

  @override
  void removeLivestreamEventListener(RtkLivestreamEventListener listener) {
    return _livestreamListener.detach(listener);
  }

  @override
  RtkLivestream get livestream => _RtkLivestreamImpl();

  @override
  StageStatus get stageStatus => _stageController.stageStatus;

  @override
  RtkStage get stage => _RtkStageImpl();

  @override
  Future<void> disableCache() async {
    await _coreMethodChannel.invokeMethod("disableCache");
  }

  @override
  Future<void> enableCache() async {
    return await _coreMethodChannel.invokeMethod("enableCache");
  }

  @override
  Future<bool> launchUrl(String url) async {
    return await _coreMethodChannel.invokeMethod("launchUrl", url);
  }

  @override
  Future<bool> release() async {
    return await _coreMethodChannel.invokeMethod('release');
  }

  @override
  Future<void> cleanNativeChatListener() async {
    removeChatEventListener(_chatController);
    await _chatListener.dispose();
    _isChatNativeListenerAttached = false;
    return;
  }

  @override
  Future<void> cleanNativeDataUpdateListener() async {
    removeDataUpdateEventListener(_dataController);
    await _dataListener.dispose();
    _isDataNativeListenerAttached = false;
    return;
  }

  @override
  Future<void> cleanNativeLivestreamListener() async {
    removeLivestreamEventListener(_livestreamController);
    await _livestreamListener.dispose();
    _isLvsNativeListenerAttached = false;
    return;
  }

  @override
  Future<void> cleanNativeMeetingRoomEventListener() async {
    await _roomEventListener.dispose();
    _isRoomNativeListenerAttached = false;
    return;
  }

  @override
  Future<void> cleanNativeParticipantsEventListener() async {
    removeParticipantsEventListener(_participantController);
    await _participantListenerChannel.dispose();
    _isParticipantNativeListenerAttached = false;
    return;
  }

  @override
  Future<void> cleanNativePluginsEventListener() async {
    await _pluginListener.dispose();
    _isPluginNativeListenerAttached = false;
    return;
  }

  @override
  Future<void> cleanNativePollListener() async {
    removePollsEventListener(_pollController);
    await _pollListener.dispose();
    _isPollNativeListenerAttached = false;
    return;
  }

  @override
  Future<void> cleanNativeRecordingListener() async {
    removeRecordingEventListener(_recordingController);
    await _recordingListener.dispose();
    _isRecordingNativeListenerAttached = false;
    return;
  }

  @override
  Future<void> cleanNativeSelfParticipantEventListener() async {
    removeSelfParticipantEventListener(_localUserController);
    await _selfListenerChannel.dispose();
    _isSelfNativeListenerAttached = false;
    return;
  }

  @override
  Future<void> cleanNativeStageEventListener() async {
    removeStageEventListener(_stageController);
    await _stageListener.dispose();
    _isStageNativeListenerAttached = false;
    return;
  }

  @override
  Future<void> cleanNativeWaitingRoomListener() async {
    await _waitingRoomListener.dispose();
    _isWaitingNativeListenerAttached = false;
    return;
  }

  @override
  Future<void> cleanAllNativeListeners() async {
    await cleanNativeMeetingRoomEventListener();
    await cleanNativeWaitingRoomListener();
    await cleanNativeParticipantsEventListener();
    await cleanNativePollListener();
    await cleanNativeRecordingListener();
    await cleanNativeStageEventListener();
    await cleanNativeSelfParticipantEventListener();
    await cleanNativeChatListener();
    await cleanNativeDataUpdateListener();
    await cleanNativeLivestreamListener();
    await cleanNativePluginsEventListener();
  }

  @override
  void setSdkInfo(String? sdkName, String? version) {
    _coreMethodChannel.invokeMethod('logSdkVersion', {
      'sdkName': sdkName,
      'version': version,
    });
    return;
  }
}

class _RtkPollImpl extends RtkPolls {
  @override
  void create({
    required String question,
    required List<String> options,
    required bool anonymous,
    required bool hideVotes,
  }) {
    if (question.isEmpty || options.any((opt) => opt.isEmpty)) {
      return;
    }

    Map<String, dynamic> pollChars = {
      'question': question,
      'options': options,
      'anonymous': anonymous,
      'hideVotes': hideVotes,
    };

    _coreMethodChannel.invokeMethod(
      "createPoll",
      pollChars,
    );
  }

  @override
  void vote({
    required Poll poll,
    required PollOption pollOption,
  }) {
    Map<String, dynamic> pollVote = {
      "pollMessage": poll.toMap(),
      "pollOption": pollOption.toMap()
    };
    _coreMethodChannel.invokeMethod("votePoll", pollVote);
  }
}

class _LocalUserApiAndroidImpl extends RtkLocalUserApi {
  final MethodChannel _channel;
  _LocalUserApiAndroidImpl(this._channel);

  @override
  Future<void> disableAudio({
    OnResult? onResult,
  }) async {
    final result = await _coreMethodChannel.invokeMethod('disableAudio');
    if (result != null) {
      final error = AudioErrorUtils.fromErrorCode(errorCode: result);
      if (onResult != null) {
        onResult(error);
      }
    }
  }

  @override
  Future<void> disableVideo({
    OnResult? onResult,
  }) async {
    final result = await _coreMethodChannel.invokeMethod('disableVideo');
    if (result != null) {
      final error = VideoErrorUtils.fromErrorCode(errorCode: result);
      if (onResult != null) {
        onResult(error);
      }
    }
  }

  @override
  Future<void> enableAudio({
    OnResult? onResult,
  }) async {
    final result = await _coreMethodChannel.invokeMethod('enableAudio');
    if (result != null) {
      final error = AudioErrorUtils.fromErrorCode(errorCode: result);
      if (onResult != null) {
        onResult(error);
      }
    }
  }

  @override
  Future<void> enableVideo({
    OnResult? onResult,
  }) async {
    final result = await _coreMethodChannel.invokeMethod('enableVideo');
    if (result != null) {
      final error = VideoErrorUtils.fromErrorCode(errorCode: result);
      if (onResult != null) {
        onResult(error);
      }
    }
  }

  @override
  Future<List<AudioDevice>> getAudioDevices() async {
    final result = await _channel.invokeListMethod('getAudioDevices');
    final audioDevicesMap = result?.map((e) => json.encode(e)).toList();
    return audioDevicesMap?.map((e) => AudioDevice.fromJson(e)).toList() ?? [];
  }

  @override
  Future<void> setDisplayName(String name) async =>
      await _channel.invokeMethod('setDisplayName', name);

  @override
  Future<List<VideoDevice>> getVideoDevices() async {
    final result = await _channel.invokeListMethod('getVideoDevices');
    final videoDevicesMap = result?.map((e) => json.encode(e)).toList();
    return videoDevicesMap?.map((e) => VideoDevice.fromJson(e)).toList() ?? [];
  }

  @override
  Future<AudioDevice?> getSelectedAudioDevice() async {
    final result = await _channel.invokeMethod('getSelectedAudioDevice');
    if (result != null) {
      final selectedDeviceMap = json.encode(result);
      return AudioDevice.fromJson(selectedDeviceMap);
    }
    return null;
  }

  @override
  Future<VideoDevice?> getSelectedVideoDevice() async {
    final result = await _channel.invokeMethod('getSelectedVideoDevice');
    if (result != null) {
      final selectedDeviceMap = json.encode(result);
      return VideoDevice.fromJson(selectedDeviceMap);
    }
    return null;
  }

  @override
  Future<void> setAudioDevice(AudioDevice device) {
    return _channel.invokeMethod('setAudioDevice', device.toMap());
  }

  @override
  Future<void> setVideoDevice(VideoDevice device) {
    return _channel.invokeMethod('setVideoDevice', device.toMap());
  }

  @override
  void switchCamera() {
    _channel.invokeMethod('switchCamera');
  }

  @override
  void enableScreenshare() {
    _channel.invokeMethod('enableScreenshare');
  }

  @override
  void disableScreenshare() {
    _channel.invokeMethod('disableScreenshare');
  }
}

class _RtkChatImpl extends RtkChat {
  @override
  void sendFileMessage(String path, OnResult onResult) {
    // TODO: remove message from payload
    final payload = {'path': path, 'message': ''};
    _coreMethodChannel.invokeMethod('sendFileMessage', payload).then(
      (value) {
        if (value == null) {
          onResult(null);
          return;
        }
        final chatError = ChatErrorUtils.fromErrorCode(errorCode: value);
        onResult(chatError);
      },
    );
  }

  @override
  void sendImageMessage(String path, OnResult onResult) {
    // TODO: remove message from payload
    final payload = {'path': path, 'message': ''};
    _coreMethodChannel.invokeMethod('sendImageMessage', payload).then(
      (value) {
        if (value == null) {
          onResult(null);
          return;
        }
        final chatError = ChatErrorUtils.fromErrorCode(errorCode: value);
        onResult(chatError);
      },
    );
  }

  @override
  void sendTextMessage(String message) {
    if (message.isEmpty) return;
    _coreMethodChannel.invokeMethod('sendTextMessage', message);
  }

  @override
  void downloadAttachment(String url, {String fileName = ""}) {
    if (url.isEmpty) return;
    _coreMethodChannel
        .invokeMethod('downloadAttachment', {"url": url, "fileName": fileName});
  }
}

class _RtkRecordingImpl extends RtkRecording {
  @override
  void start(OnResult onResult) {
    _coreMethodChannel.invokeMethod("startRecording").then(
      (value) {
        if (value == null) {
          onResult(null);
          return;
        }
        final recordingError =
            RecordingErrorUtils.fromErrorCode(errorCode: value);
        onResult(recordingError);
      },
    );
  }

  @override
  void stop(OnResult onResult) {
    _coreMethodChannel.invokeMethod("stopRecording").then(
      (value) {
        if (value == null) {
          onResult(null);
          return;
        }
        final recordingError =
            RecordingErrorUtils.fromErrorCode(errorCode: value);
        onResult(recordingError);
      },
    );
  }
}

class _RtkPluginApi extends RtkPluginApi {
  @override
  void activate(String id) {
    _coreMethodChannel.invokeMethod("activatePlugin", id);
  }

  @override
  void deactivate(String id) {
    _coreMethodChannel.invokeMethod("deactivatePlugin", id);
  }
}

class _RtkPluginsImpl extends RtkPlugins {
  final RtkDataController _dataController;
  final RtkPluginsController _pluginsController;
  _RtkPluginsImpl(this._dataController, this._pluginsController);

  @override
  List<RtkPlugin> get all => _dataController.plugins;

  @override
  List<RtkPlugin> get active => _pluginsController.activePlugins;
}

class _RtkJoinedMeetingParticipantApiImpl
    extends RtkJoinedMeetingParticipantApi {
  @override
  void disableAudio(String id, {OnResult? onResult}) {
    _coreMethodChannel.invokeMethod("disableParticipantAudio", id).then(
      (value) {
        if (value != null) {
          final error = HostErrorUtils.fromErrorCode(errorCode: value);
          if (onResult != null) {
            onResult(error);
          }
        }
      },
    );
  }

  @override
  void disableVideo(String id, {OnResult? onResult}) {
    _coreMethodChannel.invokeMethod("disableParticipantVideo", id).then(
      (value) {
        if (value != null) {
          final error = HostErrorUtils.fromErrorCode(errorCode: value);
          if (onResult != null) {
            onResult(error);
          }
        }
      },
    );
  }

  @override
  void kick(String id, {OnResult? onResult}) {
    _coreMethodChannel.invokeMethod('kickParticipant', id).then(
      (value) {
        if (value != null) {
          final error = HostErrorUtils.fromErrorCode(errorCode: value);
          if (onResult != null) {
            onResult(error);
          }
        }
      },
    );
  }
}

class _RtkMeetingParticipantApiImpl extends RtkMeetingParticipantApi {
  @override
  void addParticipantUpdateListener(String id) {
    _coreMethodChannel.invokeMethod("addParticipantUpdateListener", id);
  }

  @override
  void removeParticipantUpdateListener(String id) {
    _coreMethodChannel.invokeMethod("removeParticipantUpdateListener", id);
  }

  @override
  void removeParticipantUpdateListeners() {
    _coreMethodChannel.invokeMethod("removeParticipantUpdateListeners");
  }

  @override
  void pin(String participantId) {
    _coreMethodChannel.invokeMethod("pinParticipant", participantId);
    return;
  }

  @override
  void unpin() {
    _coreMethodChannel.invokeMethod("unpinParticipant");
    return;
  }
}

class _WaitlistingApi extends RtkWaitlistedParticipantApi {
  @override
  void acceptWaitListedRequest(String id) {
    _coreMethodChannel.invokeMethod("acceptWaitListedRequest", id);
  }

  @override
  void rejectWaitlistRequest(String id) {
    _coreMethodChannel.invokeMethod("rejectWaitListedRequest", id);
  }
}

class _RtkStageImpl extends RtkStage {
  @override
  void requestAccess() {
    _coreMethodChannel.invokeMethod("requestStageAccess");
  }

  @override
  void cancelRequestAccess() {
    _coreMethodChannel.invokeMethod("cancelRequestAccess");
  }

  @override
  void grantAccess(List<String> peerIds) {
    _coreMethodChannel.invokeMethod("grantAccessToStage", peerIds);
  }

  @override
  void denyAccess(List<String> peerIds) {
    _coreMethodChannel.invokeMethod("denyAccessToStage", peerIds);
  }

  @override
  void join() {
    _coreMethodChannel.invokeMethod("joinStage");
  }

  @override
  void leave() {
    _coreMethodChannel.invokeMethod("leaveStage");
  }

  @override
  void kick(List<String> peerIds) {
    _coreMethodChannel.invokeMethod("kickPeerFromStage", peerIds);
  }
}

class _RtkLivestreamImpl extends RtkLivestream {
  @override
  void start() {
    _coreMethodChannel.invokeMethod("goLive");
  }

  @override
  void stop() {
    _coreMethodChannel.invokeMethod("stopLive");
  }
}
