// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';
import 'package:realtimekit_core_platform_interface/src/types/errors/rtk_error.dart';

import '../utils/int_to_bool_convertor.dart';

/// [RtkParticipants] represents all the participants in the meeting (except the local user). It provides views to the current participants in the meeting as well as methods to modify them.
class RtkParticipants {
  /// List of waitlisted participants
  final List<RtkRemoteParticipant> waitlisted;

  /// List of joined participants
  final List<RtkRemoteParticipant> joined;

  /// List of active participants
  final List<RtkRemoteParticipant> active;

  /// List of screenshares participants
  final List<RtkRemoteParticipant> screenshares;

  /// Grid pages info
  final GridPagesInfo grid;

  /// Pinned participant
  RtkRemoteParticipant? pinned;

  final RtkParticipantsApi _rtkParticipantsApi;
  RtkParticipants(
    this._rtkParticipantsApi, {
    required this.grid,
    required this.waitlisted,
    required this.joined,
    required this.active,
    required this.screenshares,
    required this.pinned,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'waitlisted': waitlisted.map((x) => x.toMap()).toList(),
      'joined': joined.map((x) => x.toMap()).toList(),
      'active': active.map((x) => x.toMap()).toList(),
      'screenshares': screenshares.map((x) => x.toMap()).toList(),
      'pinned': pinned?.toMap(),
    };
  }

  void addJoined(RtkRemoteParticipant participant) {
    joined.add(participant);
  }

  void removeJoined(RtkRemoteParticipant participant) =>
      joined.remove(participant);
  void updateJoined(RtkRemoteParticipant participant) {
    joined.removeWhere((element) => element.id == participant.id);
    joined.add(participant);
  }

  void addWaitlisted(RtkRemoteParticipant participant) =>
      waitlisted.add(participant);
  void removeWaitlisted(RtkRemoteParticipant participant) =>
      waitlisted.remove(participant);
  void updateWaitlisted(RtkRemoteParticipant participant) {
    for (final element in waitlisted) {
      if (element.id == participant.id) {
        removeWaitlisted(element);
      }
    }
    addWaitlisted(participant);
  }

  void addScreenshares(RtkRemoteParticipant participant) =>
      screenshares.add(participant);
  void removeScreenshares(RtkRemoteParticipant participant) =>
      screenshares.remove(participant);
  void updateScreenshares(RtkRemoteParticipant participant) {
    for (final element in screenshares) {
      if (element.id == participant.id) {
        removeScreenshares(element);
      }
    }
    addScreenshares(participant);
  }

  void addActive(RtkRemoteParticipant participant) => active.add(participant);
  void removeActive(RtkRemoteParticipant participant) =>
      active.remove(participant);
  void updateActive(RtkRemoteParticipant participant) {
    for (final element in active) {
      if (element.id == participant.id) {
        removeActive(element);
      }
    }
    addActive(participant);
  }

  factory RtkParticipants.fromMap(
    Map<String, dynamic> map,
    RtkJoinedMeetingParticipantApi joinedMeetingParticipantApi,
    RtkMeetingParticipantApi meetingParticipantApi,
    RtkLocalUserApi localUserApi,
    RtkWaitlistedParticipantApi waitlistedParticipantApi,
    RtkParticipantsApi participantsApi,
  ) {
    return RtkParticipants(
      participantsApi,
      waitlisted: map['waitlisted'] != null
          ? List<RtkRemoteParticipant>.from(map['waitlisted'].map((x) =>
              RtkRemoteParticipant.fromMap(x, joinedMeetingParticipantApi,
                  meetingParticipantApi, waitlistedParticipantApi)))
          : [],
      joined: map['joined'] != null
          ? List<RtkRemoteParticipant>.from(map['joined'].map((x) =>
              RtkRemoteParticipant.fromMap(x, joinedMeetingParticipantApi,
                  meetingParticipantApi, waitlistedParticipantApi)))
          : [],
      active: map['active'] != null
          ? List<RtkRemoteParticipant>.from(map['active'].map((x) =>
              RtkRemoteParticipant.fromMap(x, joinedMeetingParticipantApi,
                  meetingParticipantApi, waitlistedParticipantApi)))
          : [],
      screenshares: map['screenshares'] != null
          ? List<RtkRemoteParticipant>.from(map['screenshares'].map((x) =>
              RtkRemoteParticipant.fromMap(x, joinedMeetingParticipantApi,
                  meetingParticipantApi, waitlistedParticipantApi)))
          : [],
      pinned: map['pinned'] != null
          ? RtkRemoteParticipant.fromMap(
              map['pinned'],
              joinedMeetingParticipantApi,
              meetingParticipantApi,
              waitlistedParticipantApi)
          : null,
      grid: GridPagesInfo.fromMap(map['grid']),
    );
  }

  String toJson() => json.encode(toMap());

  factory RtkParticipants.fromJson(
    String source,
    RtkJoinedMeetingParticipantApi joinedMeetingParticipantApi,
    RtkLocalUserApi localUserApi,
    RtkWaitlistedParticipantApi waitlistedParticipantApi,
    RtkMeetingParticipantApi meetingParticipantApi,
    RtkParticipantsApi participantsApi,
  ) =>
      RtkParticipants.fromMap(
        json.decode(source),
        joinedMeetingParticipantApi,
        meetingParticipantApi,
        localUserApi,
        waitlistedParticipantApi,
        participantsApi,
      );

  @override
  String toString() {
    return 'RtkRoomParticipants(waitlisted: $waitlisted, joined: $joined, active: $active, screenshares: $screenshares, grid: $grid, pinned: $pinned)';
  }

  /// Used to set the page number while paginating the participants
  void setPage(int pageNumber) => _rtkParticipantsApi.setPage(pageNumber);

  /// Used to disable all the videos of the participants
  void disableAllVideo({OnResult? onResult}) =>
      _rtkParticipantsApi.disableAllVideo(onResult: onResult);

  /// Used to disable all the audio of the participants
  void disableAllAudio({OnResult? onResult}) =>
      _rtkParticipantsApi.disableAllAudio(onResult: onResult);

  /// Used to broadcast the message to the participants
  void broadcastMessage(String type, Map<String, dynamic> payload) {
    return _rtkParticipantsApi.broadcastMessage(type, payload);
  }

  /// Used to kick all the participants from the room
  void kickAll({OnResult? onResult}) =>
      _rtkParticipantsApi.kickAll(onResult: onResult);

  /// Used to accept the waitlisted participant object as parameter and accepts the waitlisted participant into the meeting room.
  void acceptWaitlistedParticipant(
          RtkMeetingParticipant waitlistingParticipant) =>
      _rtkParticipantsApi.acceptWaitlistedParticipant(waitlistingParticipant);

  /// Used to reject the waitlisted participant object as parameter and rejects the waitlisted participant from the meeting room.
  void rejectWaitlistedParticipant(
          RtkMeetingParticipant waitlistingParticipant) =>
      _rtkParticipantsApi.rejectWaitlistedParticipant(waitlistingParticipant);

  /// Used to accept all the waitlisted participants into the meeting room.
  void acceptAllWaitingRoomRequests() =>
      _rtkParticipantsApi.acceptAllWaitingRoomRequests();
}

abstract class RtkParticipantsApi {
  void setPage(int pageNumber);
  void disableAllVideo({OnResult? onResult});
  void disableAllAudio({OnResult? onResult});
  void kickAll({OnResult? onResult});
  void acceptWaitlistedParticipant(
      RtkMeetingParticipant waitlistingParticipant);
  void rejectWaitlistedParticipant(
      RtkMeetingParticipant waitlistingParticipant);
  void broadcastMessage(String type, Map<String, dynamic> payload);
  void acceptAllWaitingRoomRequests();
}

/// [RtkGridPagesInfo] class is used to store the grid pages information.
/// It is used to paginate the participants in the grid view.
class RtkGridPagesInfo {
  /// [pageCount] is the total number of pages in the grid view.
  int pageCount;

  /// [currentPageNumber] is the current page number in the grid view.
  int currentPageNumber;

  /// [shouldShowPaginator] is a boolean value that indicates whether the paginator should be shown or not.
  bool shouldShowPaginator;

  /// [isNextPagePossible] is a boolean value that indicates whether navigating to next page is possible or not.
  bool isNextPagePossible;

  /// [isPreviousPagePossible] is a boolean value that indicates whether navigating to previous page is possible or not.
  bool isPreviousPagePossible;

  RtkGridPagesInfo({
    required this.currentPageNumber,
    required this.isNextPagePossible,
    required this.isPreviousPagePossible,
    required this.pageCount,
    required this.shouldShowPaginator,
  });

  factory RtkGridPagesInfo.fromJson(String map) {
    return RtkGridPagesInfo.fromMap(json.decode(map));
  }

  factory RtkGridPagesInfo.fromMap(Map<String, dynamic> map) {
    return RtkGridPagesInfo(
      currentPageNumber: map["currentPageNumber"],
      pageCount: map["pageCount"],
      isNextPagePossible: decodeBool(map["isNextPagePossible"]),
      isPreviousPagePossible: decodeBool(map["isPreviousPagePossible"]),
      shouldShowPaginator: decodeBool(map["shouldShowPaginator"]),
    );
  }

  @override
  String toString() {
    return 'RtkGridPagesInfo(pageCount: $pageCount, currentPageNumber: $currentPageNumber, shouldShowPaginator: $shouldShowPaginator, isNextPagePossible: $isNextPagePossible, isPreviousPagePossible: $isPreviousPagePossible)';
  }
}

class RtkMeetingParticipant {
  /// [id] aka peerId, this is session dependent id of a user, so if you join a meeting again, you will have a fresh peerId.
  final String id;

  /// [userId] is the unique identifier of the user.
  final String userId;

  /// [name] is the display name of the user.
  final String name;

  /// [picture] is an optional URL to the user's avatar.
  final String? picture;

  /// [isHost] is a boolean value that indicates whether the user is the host or not.
  final bool isHost;

  /// [customParticipantId] is a developer-provided ID that can be set when creating the participant using the REST API.
  final String? customParticipantId;

  /// [flags] contains additional metadata about the participant such as whether they are hidden.
  final ParticipantFlags flags;

  final RtkMeetingParticipantApi meetingParticipantApi;

  /// [audioEnabled] is a boolean value that indicates whether the user's audio is enabled or not.
  bool audioEnabled;

  /// [videoEnabled] is a boolean value that indicates whether the user's video is enabled or not.
  bool videoEnabled;

  /// [screenShareEnabled] is a boolean value that indicates whether the user's screen share is enabled or not.
  bool screenShareEnabled;

  /// [isPinned] is a boolean value that indicates whether the user is pinned or not.
  bool isPinned;

  /// [stageStatus] is the stage status of the participant.
  StageStatus stageStatus;
  final RtkWaitlistedParticipantApi? waitlistedParticipantApi;

  final String presetName;

  RtkMeetingParticipant(
    this.meetingParticipantApi, {
    this.waitlistedParticipantApi,
    required this.id,
    required this.userId,
    required this.name,
    this.picture,
    required this.isHost,
    this.customParticipantId,
    required this.stageStatus,
    required this.flags,
    this.audioEnabled = false,
    this.videoEnabled = false,
    this.screenShareEnabled = false,
    this.isPinned = false,
    required this.presetName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'name': name,
      'picture': picture,
      'isHost': isHost,
      'customParticipantId': customParticipantId,
      'flags': flags.toMap(),
      'audioEnabled': audioEnabled,
      'videoEnabled': videoEnabled,
      'screenShareEnabled': screenShareEnabled,
      'isPinned': isPinned,
      'stageStatus': stageStatus.name,
      'presetName': presetName,
    };
  }

  void addParticipantUpdateListener() =>
      meetingParticipantApi.addParticipantUpdateListener(id);

  void removeParticipantUpdateListener() =>
      meetingParticipantApi.removeParticipantUpdateListener(id);

  void removeParticipantUpdateListeners() =>
      meetingParticipantApi.removeParticipantUpdateListeners();

  /// Used to accept the waitlisted request of the participant matching the provided [id].
  void acceptWaitListedRequest(String id) =>
      waitlistedParticipantApi?.acceptWaitListedRequest(id);

  /// Used to reject the waitlisted request of the participant matching the provided [id].
  void rejectWaitListedRequest(String id) =>
      waitlistedParticipantApi?.rejectWaitlistRequest(id);

  /// Used to pins the participant in the meeting.
  void pin() => meetingParticipantApi.pin(id);

  /// Used to unpins the participant from the meeting.
  void unpin() => meetingParticipantApi.unpin();

  @override
  String toString() {
    return 'RtkMeetingParticipant(id: $id, userId: $userId, name: $name, picture: $picture, isHost: $isHost, customParticipantId: $customParticipantId, flags: $flags, audioEnabled: $audioEnabled, videoEnabled: $videoEnabled, screenShareEnabled: $screenShareEnabled, isPinned: $isPinned, stageStatus: ${stageStatus.name}, presetName: $presetName)';
  }

  @override
  bool operator ==(covariant RtkMeetingParticipant other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.name == name &&
        other.picture == picture &&
        other.isHost == isHost &&
        other.customParticipantId == customParticipantId &&
        other.flags == flags &&
        other.meetingParticipantApi == meetingParticipantApi &&
        other.audioEnabled == audioEnabled &&
        other.videoEnabled == videoEnabled &&
        other.screenShareEnabled == screenShareEnabled &&
        other.isPinned == isPinned &&
        other.stageStatus == stageStatus &&
        other.presetName == presetName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        name.hashCode ^
        picture.hashCode ^
        isHost.hashCode ^
        customParticipantId.hashCode ^
        flags.hashCode ^
        meetingParticipantApi.hashCode ^
        audioEnabled.hashCode ^
        videoEnabled.hashCode ^
        screenShareEnabled.hashCode ^
        isPinned.hashCode ^
        stageStatus.hashCode;
  }
}

abstract class RtkJoinedMeetingParticipantApi {
  void disableAudio(String id, {OnResult? onResult});
  void disableVideo(String id, {OnResult? onResult});
  void kick(String id, {OnResult? onResult});
}

abstract class RtkMeetingParticipantApi {
  void addParticipantUpdateListener(String id);
  void removeParticipantUpdateListener(String id);
  void removeParticipantUpdateListeners();
  void pin(String id);
  void unpin();
}

class RtkRemoteParticipant extends RtkMeetingParticipant {
  RtkRemoteParticipant(
    super.meetingParticipantApi,
    this.joinedParticipantApis, {
    required super.waitlistedParticipantApi,
    required super.id,
    required super.userId,
    required super.name,
    required super.isHost,
    required super.flags,
    super.audioEnabled,
    super.videoEnabled,
    super.screenShareEnabled,
    super.isPinned,
    super.customParticipantId,
    super.picture,
    required super.stageStatus,
    required super.presetName,
  });

  final RtkJoinedMeetingParticipantApi joinedParticipantApis;

  /// Used to disable the audio of the remote participant.
  void disableAudio({OnResult? onResult}) =>
      joinedParticipantApis.disableAudio(id, onResult: onResult);

  /// Used to disable the video of the remote participant.
  void disableVideo({OnResult? onResult}) =>
      joinedParticipantApis.disableVideo(id, onResult: onResult);

  /// Used to kick the remote participant from the meeting.
  void kick({OnResult? onResult}) =>
      joinedParticipantApis.kick(id, onResult: onResult);

  /// Used to get the video view of the remote participant.
  VideoView get videoView => VideoView(meetingParticipant: this);

  factory RtkRemoteParticipant.fromMap(
    Map<String, dynamic> map,
    RtkJoinedMeetingParticipantApi joinedMeetingParticipantApi,
    RtkMeetingParticipantApi meetingParticipantApi,
    RtkWaitlistedParticipantApi waitlistedParticipantApi,
  ) {
    return RtkRemoteParticipant(
      meetingParticipantApi,
      joinedMeetingParticipantApi,
      waitlistedParticipantApi: waitlistedParticipantApi,
      id: map['id'],
      userId: map['userId'],
      name: map['name'],
      picture: map['picture'],
      isHost: decodeBool(map['isHost']),
      customParticipantId: map['customParticipantId'],
      flags: ParticipantFlags.fromMap(map['flags']),
      audioEnabled: decodeBool(map['audioEnabled']),
      videoEnabled: decodeBool(map['videoEnabled']),
      screenShareEnabled: decodeBool(map['screenShareEnabled']),
      isPinned: decodeBool(map['isPinned']),
      stageStatus: StageStatus.fromName(map['stageStatus']),
      presetName: map['presetName'] ?? '',
    );
  }

  factory RtkRemoteParticipant.fromJson(
    String source,
    RtkJoinedMeetingParticipantApi joinedMeetingParticipantApi,
    RtkMeetingParticipantApi meetingParticipantApi,
    RtkWaitlistedParticipantApi waitlistedParticipantApi,
  ) =>
      RtkRemoteParticipant.fromMap(
        json.decode(source),
        joinedMeetingParticipantApi,
        meetingParticipantApi,
        waitlistedParticipantApi,
      );

  RtkRemoteParticipant copyWith({
    String? id,
    String? userId,
    String? name,
    String? picture,
    bool? isHost,
    String? presetName,
    String? customParticipantId,
    ParticipantFlags? flags,
    bool? audioEnabled,
    bool? videoEnabled,
    bool? screenShareEnabled,
    bool? isPinned,
    StageStatus? stageStatus,
  }) {
    return RtkRemoteParticipant(
      meetingParticipantApi,
      joinedParticipantApis,
      waitlistedParticipantApi: waitlistedParticipantApi,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      picture: picture ?? this.picture,
      isHost: isHost ?? this.isHost,
      customParticipantId: customParticipantId ?? this.customParticipantId,
      flags: flags ?? this.flags,
      audioEnabled: audioEnabled ?? this.audioEnabled,
      videoEnabled: videoEnabled ?? this.videoEnabled,
      screenShareEnabled: screenShareEnabled ?? this.screenShareEnabled,
      isPinned: isPinned ?? this.isPinned,
      stageStatus: stageStatus ?? this.stageStatus,
      presetName: presetName ?? this.presetName,
    );
  }
}

class RtkSelfParticipant extends RtkMeetingParticipant {
  final SelfPermissions permissions;
  final RtkLocalUserApi localUserApis;

  final bool isCameraPermissionGranted;
  final bool isMicrophonePermissionGranted;

  RtkSelfParticipant(
    this.localUserApis,
    super.meetingParticipantApi, {
    required this.isCameraPermissionGranted,
    required this.isMicrophonePermissionGranted,
    super.waitlistedParticipantApi,
    required super.id,
    required super.userId,
    required super.name,
    required super.isHost,
    required super.flags,
    super.audioEnabled,
    required this.permissions,
    super.videoEnabled,
    super.screenShareEnabled,
    super.isPinned,
    super.customParticipantId,
    super.picture,
    required super.stageStatus,
    required super.presetName,
  });

  void disableAudio({OnResult? onResult}) =>
      localUserApis.disableAudio(onResult: onResult);

  void enableAudio({OnResult? onResult}) =>
      localUserApis.enableAudio(onResult: onResult);

  void disableVideo({OnResult? onResult}) =>
      localUserApis.disableVideo(onResult: onResult);

  void enableVideo({OnResult? onResult}) =>
      localUserApis.enableVideo(onResult: onResult);

  Future<List<AudioDevice>> getAudioDevices() async =>
      localUserApis.getAudioDevices();

  Future<List<VideoDevice>> getVideoDevices() async =>
      localUserApis.getVideoDevices();

  Future<void> setAudioDevice(AudioDevice device) async =>
      localUserApis.setAudioDevice(device);

  Future<void> setVideoDevice(VideoDevice device) async =>
      localUserApis.setVideoDevice(device);

  Future<AudioDevice?> getSelectedAudioDevice() async =>
      localUserApis.getSelectedAudioDevice();

  Future<VideoDevice?> getSelectedVideoDevice() async =>
      localUserApis.getSelectedVideoDevice();

  void switchCamera() => localUserApis.switchCamera();

  void enableScreenShare() => localUserApis.enableScreenshare();

  void disableScreenShare() => localUserApis.disableScreenshare();

  Future<void> setDisplayName(String name) async =>
      await localUserApis.setDisplayName(name);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'name': name,
      'picture': picture,
      'isHost': isHost,
      'customParticipantId': customParticipantId,
      'flags': flags.toMap(),
      'audioEnabled': audioEnabled,
      'videoEnabled': videoEnabled,
      'screenShareEnabled': screenShareEnabled,
      'isPinned': isPinned,
      'stageStatus': stageStatus.name,
    };
  }

  factory RtkSelfParticipant.fromMap(
    Map<String, dynamic> map,
    RtkLocalUserApi userApi,
    RtkJoinedMeetingParticipantApi joinedMeetingParticipantApi,
    RtkMeetingParticipantApi meetingParticipantApi,
  ) {
    return RtkSelfParticipant(
      userApi,
      meetingParticipantApi,
      isCameraPermissionGranted:
          decodeBool(map['systemPermissions']['isCameraPermissionGranted']),
      isMicrophonePermissionGranted:
          decodeBool(map['systemPermissions']['isMicrophonePermissionGranted']),
      id: map['id'] as String,
      userId: map['userId'] as String,
      name: map['name'] as String,
      picture: map['picture'] != null ? map['picture'] as String : null,
      isHost: decodeBool(map['isHost']),
      customParticipantId: map['customParticipantId'] != null
          ? map['customParticipantId'] as String
          : null,
      flags: ParticipantFlags.fromMap(map['flags'] as Map<String, dynamic>),
      audioEnabled: decodeBool(map['audioEnabled']),
      videoEnabled: decodeBool(map['videoEnabled']),
      screenShareEnabled: decodeBool(map['screenShareEnabled']),
      isPinned: decodeBool(map['isPinned']),
      permissions: SelfPermissions.fromMap(
          map['selfPermissions'] as Map<String, dynamic>),
      stageStatus: StageStatus.fromName(map['stageStatus'] as String),
      presetName: map['presetName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RtkSelfParticipant.fromJson(
    String source,
    RtkLocalUserApi localUserApi,
    RtkJoinedMeetingParticipantApi joinedMeetingParticipantApi,
    RtkMeetingParticipantApi meetingParticipantApi,
  ) =>
      RtkSelfParticipant.fromMap(
        json.decode(source) as Map<String, dynamic>,
        localUserApi,
        joinedMeetingParticipantApi,
        meetingParticipantApi,
      );

  @override
  String toString() {
    return 'RtkLocalUser(id: $id, userId: $userId, name: $name, picture: $picture, isHost: $isHost, customParticipantId: $customParticipantId, flags: $flags, audioEnabled: $audioEnabled, videoEnabled: $videoEnabled, screenShareEnabled: $screenShareEnabled, isPinned: $isPinned, permissions: $permissions, stageStatus: ${stageStatus.name})';
  }

  @override
  bool operator ==(covariant RtkSelfParticipant other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.name == name &&
        other.picture == picture &&
        other.isHost == isHost &&
        other.customParticipantId == customParticipantId &&
        other.flags == flags &&
        other.audioEnabled == audioEnabled &&
        other.videoEnabled == videoEnabled &&
        other.screenShareEnabled == screenShareEnabled &&
        other.isPinned == isPinned &&
        other.permissions == permissions &&
        other.stageStatus == stageStatus;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        name.hashCode ^
        picture.hashCode ^
        isHost.hashCode ^
        customParticipantId.hashCode ^
        flags.hashCode ^
        audioEnabled.hashCode ^
        videoEnabled.hashCode ^
        screenShareEnabled.hashCode ^
        isPinned.hashCode ^
        permissions.hashCode ^
        stageStatus.hashCode;
  }
}

abstract class RtkWaitlistedParticipantApi {
  void acceptWaitListedRequest(String id);
  void rejectWaitlistRequest(String id);
}

/// [ParticipantFlags] class is used to store the participant flags.
class ParticipantFlags {
  /// [recorder] is a boolean value that indicates whether the participant is a recorder or not.
  final bool recorder;

  /// [hiddenParticipant] is a boolean value that indicates whether the participant is hidden or not.
  final bool hiddenParticipant;

  /// [webinarHiddenParticipant] is a boolean value that indicates whether the participant is hidden in webinar or not.
  final bool webinarHiddenParticipant;
  ParticipantFlags({
    required this.recorder,
    required this.hiddenParticipant,
    required this.webinarHiddenParticipant,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'recorder': recorder,
      'hiddenParticipant': hiddenParticipant,
      'webinarHiddenParticipant': webinarHiddenParticipant,
    };
  }

  factory ParticipantFlags.fromMap(Map<String, dynamic> map) {
    return ParticipantFlags(
      recorder: decodeBool(map['recorder']),
      hiddenParticipant: decodeBool(map['hiddenParticipant']),
      webinarHiddenParticipant: decodeBool(map['webinarHiddenParticipant']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ParticipantFlags.fromJson(String source) =>
      ParticipantFlags.fromMap(json.decode(source));
}
