// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:realtimekit_core_platform_interface/src/utils/int_to_bool_convertor.dart';

class SelfPermissions {
  final ChatPermissions chat;
  final HostPermissions host;
  final MediaPermissions media;
  final PluginPermissions plugin;
  final PollPermissions poll;
  final MiscellaneousPermissions miscellaneous;
  final LivestreamPermissions livestream;
  final ParticipantPresetConfig userConfig;
  // TODO: add privateChatPermissions

  SelfPermissions({
    required this.chat,
    required this.host,
    required this.media,
    required this.plugin,
    required this.poll,
    required this.miscellaneous,
    required this.livestream,
    required this.userConfig,
  });

  factory SelfPermissions.fromMap(Map<String, dynamic> map) {
    return SelfPermissions(
      chat: ChatPermissions.fromMap(map['chat'] as Map<String, dynamic>),
      host: HostPermissions.fromMap(map['host'] as Map<String, dynamic>),
      media: MediaPermissions.fromMap(map['media'] as Map<String, dynamic>),
      plugin: PluginPermissions.fromMap(map['plugins'] as Map<String, dynamic>),
      poll: PollPermissions.fromMap(map['polls'] as Map<String, dynamic>),
      miscellaneous: MiscellaneousPermissions.fromMap(
          map['miscellaneous'] as Map<String, dynamic>),
      livestream: LivestreamPermissions.fromMap(
          map['livestream'] as Map<String, dynamic>),
      userConfig: ParticipantPresetConfig.fromJson(map['config']),
      // stage: StagePermissions.fromMap(map['stage'] as Map<String, dynamic>),
    );
  }

  factory SelfPermissions.fromJson(String source) {
    return SelfPermissions.fromMap(json.decode(source) as Map<String, dynamic>);
  }

  factory SelfPermissions.empty() => SelfPermissions(
        chat: ChatPermissions(
          canSendText: false,
          canSendFiles: false,
        ),
        host: HostPermissions(
          canMuteAudio: false,
          canKickParticipant: false,
          canPinParticipant: false,
          canTriggerRecording: false,
          canMuteVideo: false,
          canAcceptRequests: false,
          canAcceptStageRequests: false,
        ),
        media: MediaPermissions(
          audio: MediaPermission.allowed,
          video: VideoPermissions(
            permission: MediaPermission.allowed,
            quality: '480p',
            frameRate: 30,
          ),
          screenshare: MediaPermission.allowed,
        ),
        plugin: PluginPermissions(
          canClose: false,
          canLaunch: false,
        ),
        poll: PollPermissions(
          canCreate: false,
          canVote: false,
          canView: false,
        ),
        miscellaneous: MiscellaneousPermissions(
          canEditDisplayName: false,
          isHiddenParticipant: false,
          canSpotLight: false,
          stageEnabled: false,
          stageAccess: MediaPermission.notAllowed,
        ),
        livestream: LivestreamPermissions(
          canLivestream: false,
        ),
        userConfig: ParticipantPresetConfig(
          viewType: '',
          media: RtkMediaConfig(
            screenshare: RtkVideoConfig(quality: '480p', frameRate: 30),
            video: RtkVideoConfig(quality: '480p', frameRate: 30),
          ),
          videoStreamConfig: RtkVideoStreamConfig(mobile: 30, desktop: 30),
          maxScreenShareCount: 0,
        ),
      );
}

class ChatPermissions {
  final bool canSendText;
  final bool canSendFiles;

  ChatPermissions({
    required this.canSendText,
    required this.canSendFiles,
  });

  factory ChatPermissions.fromMap(Map<String, dynamic> map) {
    return ChatPermissions(
      canSendText: decodeBool(map["canSendText"]),
      canSendFiles: decodeBool(map["canSendFiles"]),
    );
  }
}

class HostPermissions {
  final bool canKickParticipant;
  final bool canMuteAudio;
  final bool canMuteVideo;
  final bool canPinParticipant;
  final bool canTriggerRecording;
  final bool canAcceptRequests;
  final bool canAcceptStageRequests;

  HostPermissions({
    required this.canKickParticipant,
    required this.canMuteAudio,
    required this.canMuteVideo,
    required this.canPinParticipant,
    required this.canTriggerRecording,
    required this.canAcceptRequests,
    required this.canAcceptStageRequests,
  });

  @override
  String toString() {
    return 'HostPermissions(canKickParticipant: $canKickParticipant, canMuteAudio: $canMuteAudio, canMuteVideo: $canMuteVideo, canPinParticipant: $canPinParticipant, canTriggerRecording: $canTriggerRecording, canAcceptRequests: $canAcceptRequests, canAcceptStageRequests: $canAcceptStageRequests)';
  }

  HostPermissions copyWith({
    bool? canKickParticipant,
    bool? canMuteAudio,
    bool? canMuteVideo,
    bool? canPinParticipant,
    bool? canTriggerRecording,
    bool? canAcceptRequests,
    bool? canAcceptStageRequests,
  }) {
    return HostPermissions(
      canKickParticipant: canKickParticipant ?? this.canKickParticipant,
      canMuteAudio: canMuteAudio ?? this.canMuteAudio,
      canMuteVideo: canMuteVideo ?? this.canMuteVideo,
      canPinParticipant: canPinParticipant ?? this.canPinParticipant,
      canTriggerRecording: canTriggerRecording ?? this.canTriggerRecording,
      canAcceptRequests: canAcceptRequests ?? this.canAcceptRequests,
      canAcceptStageRequests:
          canAcceptStageRequests ?? this.canAcceptStageRequests,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'canKickParticipant': canKickParticipant,
      'canMuteAudio': canMuteAudio,
      'canMuteVideo': canMuteVideo,
      'canPinParticipant': canPinParticipant,
      'canTriggerRecording': canTriggerRecording,
      'canAcceptRequests': canAcceptRequests,
      'canAcceptStageRequests': canAcceptStageRequests,
    };
  }

  factory HostPermissions.fromMap(Map<String, dynamic> map) {
    return HostPermissions(
      canKickParticipant: decodeBool(map['canKickParticipant']),
      canMuteAudio: decodeBool(map['canMuteAudio']),
      canMuteVideo: decodeBool(map['canMuteVideo']),
      canPinParticipant: decodeBool(map['canPinParticipant']),
      canTriggerRecording: decodeBool(map['canTriggerRecording']),
      canAcceptRequests: decodeBool(map['canAcceptRequests']),
      canAcceptStageRequests: decodeBool(map['canAcceptStageRequests']),
    );
  }

  String toJson() => json.encode(toMap());

  factory HostPermissions.fromJson(String source) =>
      HostPermissions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant HostPermissions other) {
    if (identical(this, other)) return true;

    return other.canKickParticipant == canKickParticipant &&
        other.canMuteAudio == canMuteAudio &&
        other.canMuteVideo == canMuteVideo &&
        other.canPinParticipant == canPinParticipant &&
        other.canTriggerRecording == canTriggerRecording &&
        other.canAcceptRequests == canAcceptRequests &&
        other.canAcceptStageRequests == canAcceptStageRequests;
  }

  @override
  int get hashCode {
    return canKickParticipant.hashCode ^
        canMuteAudio.hashCode ^
        canMuteVideo.hashCode ^
        canPinParticipant.hashCode ^
        canTriggerRecording.hashCode ^
        canAcceptRequests.hashCode ^
        canAcceptStageRequests.hashCode;
  }
}

class MediaPermissions {
  final MediaPermission audio;
  final VideoPermissions video;
  final MediaPermission screenshare;

  MediaPermissions({
    required this.audio,
    required this.video,
    required this.screenshare,
  });

  factory MediaPermissions.fromMap(Map<String, dynamic> map) {
    return MediaPermissions(
        audio: MediaPermission.fromName(map["audio"]),
        video: VideoPermissions.fromJson(jsonEncode(map["video"])),
        screenshare: MediaPermission.fromName(
          map["screenshare"],
        ));
  }
}

class PluginPermissions {
  final bool canClose;
  final bool canLaunch;

  PluginPermissions({
    required this.canClose,
    required this.canLaunch,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'canClose': canClose,
      'canLaunch': canLaunch,
    };
  }

  factory PluginPermissions.fromMap(Map<String, dynamic> map) {
    return PluginPermissions(
      canClose: decodeBool(map['canClose']),
      canLaunch: decodeBool(map['canLaunch']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PluginPermissions.fromJson(String source) =>
      PluginPermissions.fromMap(json.decode(source) as Map<String, dynamic>);
}

class VideoPermissions {
  final MediaPermission permission;
  final String quality;
  final int frameRate;
  VideoPermissions({
    required this.permission,
    required this.frameRate,
    required this.quality,
  });

  factory VideoPermissions.fromMap(Map<String, dynamic> map) {
    return VideoPermissions(
      permission: MediaPermission.fromName(map['permission'] as String),
      quality: map['quality'] as String,
      frameRate: map['frameRate'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'permission': permission,
      'quality': quality,
      'frameRate': frameRate,
    };
  }

  String toJson() => json.encode(toMap());

  factory VideoPermissions.fromJson(String source) =>
      VideoPermissions.fromMap(json.decode(source) as Map<String, dynamic>);
}

class MiscellaneousPermissions {
  final bool canEditDisplayName;
  final bool isHiddenParticipant;
  final bool canSpotLight;
  final bool stageEnabled;
  final MediaPermission stageAccess;

  MiscellaneousPermissions({
    required this.canEditDisplayName,
    required this.isHiddenParticipant,
    required this.canSpotLight,
    required this.stageEnabled,
    required this.stageAccess,
  });

  MiscellaneousPermissions copyWith({
    bool? canEditDisplayName,
    bool? isHiddenParticipant,
    bool? canSpotLight,
    bool? stageEnabled,
    MediaPermission? stageAccess,
  }) {
    return MiscellaneousPermissions(
      canEditDisplayName: canEditDisplayName ?? this.canEditDisplayName,
      isHiddenParticipant: isHiddenParticipant ?? this.isHiddenParticipant,
      canSpotLight: canSpotLight ?? this.canSpotLight,
      stageEnabled: stageEnabled ?? this.stageEnabled,
      stageAccess: stageAccess ?? this.stageAccess,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'canEditDisplayName': canEditDisplayName,
      'isHiddenParticipant': isHiddenParticipant,
      'canSpotLight': canSpotLight,
      'stageEnabled': stageEnabled,
      'stageAccess': stageAccess.name,
    };
  }

  factory MiscellaneousPermissions.fromMap(Map<String, dynamic> map) {
    return MiscellaneousPermissions(
      canEditDisplayName: decodeBool(map['canEditDisplayName']),
      isHiddenParticipant: decodeBool(map['isHiddenParticipant']),
      canSpotLight: decodeBool(map['canSpotLight']),
      stageEnabled: decodeBool(map['stageEnabled']),
      stageAccess: MediaPermission.fromName(map['stageAccess'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory MiscellaneousPermissions.fromJson(String source) =>
      MiscellaneousPermissions.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MiscellaneousPermissions(canEditDisplayName: $canEditDisplayName, isHiddenParticipant: $isHiddenParticipant, canSpotLight: $canSpotLight, stageEnabled: $stageEnabled, stageAccess: $stageAccess)';
  }

  @override
  bool operator ==(covariant MiscellaneousPermissions other) {
    if (identical(this, other)) return true;

    return other.canEditDisplayName == canEditDisplayName &&
        other.isHiddenParticipant == isHiddenParticipant &&
        other.canSpotLight == canSpotLight &&
        other.stageEnabled == stageEnabled &&
        other.stageAccess == stageAccess;
  }

  @override
  int get hashCode {
    return canEditDisplayName.hashCode ^
        isHiddenParticipant.hashCode ^
        canSpotLight.hashCode ^
        stageEnabled.hashCode ^
        stageAccess.hashCode;
  }
}

class PollPermissions {
  final bool canCreate;
  final bool canVote;
  final bool canView;
  PollPermissions({
    required this.canCreate,
    required this.canVote,
    required this.canView,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'canCreate': canCreate,
      'canVote': canVote,
      'canView': canView,
    };
  }

  factory PollPermissions.fromMap(Map<String, dynamic> map) {
    return PollPermissions(
      canCreate: decodeBool(map['canCreate']),
      canVote: decodeBool(map['canVote']),
      canView: decodeBool(map['canView']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PollPermissions.fromJson(String source) =>
      PollPermissions.fromMap(json.decode(source) as Map<String, dynamic>);
}

class LivestreamPermissions {
  final bool canLivestream;
  LivestreamPermissions({
    required this.canLivestream,
  });

  LivestreamPermissions copyWith({
    bool? canLivestream,
  }) {
    return LivestreamPermissions(
      canLivestream: canLivestream ?? this.canLivestream,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'canLivestream': canLivestream,
    };
  }

  factory LivestreamPermissions.fromMap(Map<String, dynamic> map) {
    return LivestreamPermissions(
      canLivestream: decodeBool(map['canLivestream']),
    );
  }

  String toJson() => json.encode(toMap());

  factory LivestreamPermissions.fromJson(String source) =>
      LivestreamPermissions.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LivestreamPermissions(canLivestream: $canLivestream)';

  @override
  bool operator ==(covariant LivestreamPermissions other) {
    if (identical(this, other)) return true;

    return other.canLivestream == canLivestream;
  }

  @override
  int get hashCode => canLivestream.hashCode;
}

class ParticipantPresetConfig {
  final String viewType;
  final RtkMediaConfig media;
  final RtkVideoStreamConfig videoStreamConfig;
  final int maxScreenShareCount;
  ParticipantPresetConfig({
    required this.viewType,
    required this.media,
    required this.videoStreamConfig,
    required this.maxScreenShareCount,
  });

  ParticipantPresetConfig copyWith({
    String? viewType,
    RtkMediaConfig? media,
    RtkVideoStreamConfig? videoStreamConfig,
    int? maxScreenShareCount,
  }) {
    return ParticipantPresetConfig(
      viewType: viewType ?? this.viewType,
      media: media ?? this.media,
      videoStreamConfig: videoStreamConfig ?? this.videoStreamConfig,
      maxScreenShareCount: maxScreenShareCount ?? this.maxScreenShareCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'view_type': viewType,
      'media': media.toMap(),
      'max_video_streams': videoStreamConfig.toMap(),
      'max_screenshare_count': maxScreenShareCount,
    };
  }

  factory ParticipantPresetConfig.fromMap(Map<String, dynamic> map) {
    return ParticipantPresetConfig(
      viewType: map['view_type'] as String,
      media: RtkMediaConfig.fromMap(map['media'] as Map<String, dynamic>),
      videoStreamConfig: RtkVideoStreamConfig.fromMap(
          map['max_video_streams'] as Map<String, dynamic>),
      maxScreenShareCount: map['max_screenshare_count'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ParticipantPresetConfig.fromJson(String source) =>
      ParticipantPresetConfig.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RtkUserConfig(view_type: $viewType, media: $media, max_video_streams: $videoStreamConfig, maxScreenShareCount: $maxScreenShareCount)';
  }

  @override
  bool operator ==(covariant ParticipantPresetConfig other) {
    if (identical(this, other)) return true;

    return other.viewType == viewType &&
        other.media == media &&
        other.videoStreamConfig == videoStreamConfig &&
        other.maxScreenShareCount == maxScreenShareCount;
  }

  @override
  int get hashCode {
    return viewType.hashCode ^
        media.hashCode ^
        videoStreamConfig.hashCode ^
        maxScreenShareCount.hashCode;
  }
}

class RtkVideoStreamConfig {
  final int mobile;
  final int desktop;
  RtkVideoStreamConfig({
    required this.mobile,
    required this.desktop,
  });

  RtkVideoStreamConfig copyWith({
    int? mobile,
    int? desktop,
  }) {
    return RtkVideoStreamConfig(
      mobile: mobile ?? this.mobile,
      desktop: desktop ?? this.desktop,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mobile': mobile,
      'desktop': desktop,
    };
  }

  factory RtkVideoStreamConfig.fromMap(Map<String, dynamic> map) {
    return RtkVideoStreamConfig(
      mobile: map['mobile'] as int,
      desktop: map['desktop'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory RtkVideoStreamConfig.fromJson(String source) =>
      RtkVideoStreamConfig.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'RtkVideoStreamConfig(mobile: $mobile, desktop: $desktop)';

  @override
  bool operator ==(covariant RtkVideoStreamConfig other) {
    if (identical(this, other)) return true;

    return other.mobile == mobile && other.desktop == desktop;
  }

  @override
  int get hashCode => mobile.hashCode ^ desktop.hashCode;
}

class RtkMediaConfig {
  final RtkVideoConfig video;
  final RtkVideoConfig screenshare;
  RtkMediaConfig({
    required this.video,
    required this.screenshare,
  });

  RtkMediaConfig copyWith({
    RtkVideoConfig? video,
    RtkVideoConfig? screenshare,
  }) {
    return RtkMediaConfig(
      video: video ?? this.video,
      screenshare: screenshare ?? this.screenshare,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'video': video.toMap(),
      'screenshare': screenshare.toMap(),
    };
  }

  factory RtkMediaConfig.fromMap(Map<String, dynamic> map) {
    return RtkMediaConfig(
      video: RtkVideoConfig.fromMap(map['video'] as Map<String, dynamic>),
      screenshare:
          RtkVideoConfig.fromMap(map['screenshare'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory RtkMediaConfig.fromJson(String source) =>
      RtkMediaConfig.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'RtkMediaConfig(video: $video, screenshare: $screenshare)';

  @override
  bool operator ==(covariant RtkMediaConfig other) {
    if (identical(this, other)) return true;

    return other.video == video && other.screenshare == screenshare;
  }

  @override
  int get hashCode => video.hashCode ^ screenshare.hashCode;
}

class RtkVideoConfig {
  final String quality;
  final int frameRate;
  RtkVideoConfig({
    required this.quality,
    required this.frameRate,
  });

  RtkVideoConfig copyWith({
    String? quality,
    int? frameRate,
  }) {
    return RtkVideoConfig(
      quality: quality ?? this.quality,
      frameRate: frameRate ?? this.frameRate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quality': quality,
      'frame_rate': frameRate,
    };
  }

  factory RtkVideoConfig.fromMap(Map<String, dynamic> map) {
    return RtkVideoConfig(
      quality: map['quality'] as String,
      frameRate: map['frame_rate'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory RtkVideoConfig.fromJson(String source) =>
      RtkVideoConfig.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'RtkVideoConfig(quality: $quality, frame_rate: $frameRate)';

  @override
  bool operator ==(covariant RtkVideoConfig other) {
    if (identical(this, other)) return true;

    return other.quality == quality && other.frameRate == frameRate;
  }

  @override
  int get hashCode => quality.hashCode ^ frameRate.hashCode;
}

enum MediaPermission {
  allowed("ALLOWED"),
  notAllowed("NOT_ALLOWED"),
  canRequest("CAN_REQUEST");

  final String name;
  const MediaPermission(this.name);

  static MediaPermission fromName(String name) {
    return MediaPermission.values.firstWhere(
      (e) => e.name == name,
      orElse: () => MediaPermission.notAllowed,
    );
  }
}
