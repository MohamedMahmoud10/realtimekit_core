// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:realtimekit_core_platform_interface/src/listeners/rtk_livestream_events_listener.dart';

abstract class RtkLivestream {
  RtkLivestreamData get data => RtkLivestreamController.instance.data;
  void start() {}
  void stop() {}
  String? get playbackUrl => RtkLivestreamController.instance.data.playbackUrl;
  LivestreamState? getState() => RtkLivestreamController.instance.data.state;
}

class RtkLivestreamData {
  String? playbackUrl;
  LivestreamState state;
  int viewerCount;
  RtkLivestreamData({
    required this.playbackUrl,
    required this.state,
    required this.viewerCount,
  });

  RtkLivestreamData copyWith({
    String? playbackUrl,
    String? roomName,
    LivestreamState? state,
    int? viewerCount,
  }) {
    return RtkLivestreamData(
      playbackUrl: playbackUrl ?? this.playbackUrl,
      state: state ?? this.state,
      viewerCount: viewerCount ?? this.viewerCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'playbackUrl': playbackUrl,
      'state': state.name,
      'viewerCount': viewerCount,
    };
  }

  factory RtkLivestreamData.fromMap(Map<String, dynamic> map) {
    return RtkLivestreamData(
      playbackUrl: map['playbackUrl'] as String?,
      state: LivestreamState.fromName(map['state'] as String),
      viewerCount: map['viewerCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory RtkLivestreamData.fromJson(String source) =>
      RtkLivestreamData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RtkLivestreamData(playbackUrl: $playbackUrl, state: $state, viewerCount: $viewerCount)';
  }

  @override
  bool operator ==(covariant RtkLivestreamData other) {
    if (identical(this, other)) return true;

    return other.playbackUrl == playbackUrl &&
        other.state == state &&
        other.viewerCount == viewerCount;
  }

  @override
  int get hashCode {
    return playbackUrl.hashCode ^ state.hashCode ^ viewerCount.hashCode;
  }
}

enum LivestreamState {
  none("none"),
  starting("starting"),
  started("started"),
  ending("ending"),
  ended("ended"),
  errored("errored");

  final String state;
  const LivestreamState(this.state);

  static LivestreamState fromName(String name) {
    switch (name) {
      case "none":
        return LivestreamState.none;
      case "starting":
        return LivestreamState.starting;
      case "started":
        return LivestreamState.started;
      case "ending":
        return LivestreamState.ending;
      case "ended":
        return LivestreamState.ended;
      case "errored":
        return LivestreamState.errored;
      default:
        return LivestreamState.none;
    }
  }
}
