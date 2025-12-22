import 'dart:math';

import 'package:realtimekit_ui/src/data/notifiers/video_notifier.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:realtimekit_ui/src/utils/generate_key.dart';
import 'package:realtimekit_ui/src/widgets/atoms/vh_space.dart';
import 'package:realtimekit_ui/src/widgets/core/rtk_uikit_component.dart';
import 'package:realtimekit_ui/src/widgets/rtk_audio_indicator/rtk_audio_indicator_icon_widget.dart';
import 'package:realtimekit_ui/src/widgets/rtk_name_tag/rtk_name_tag.dart';
import 'package:realtimekit_ui/src/widgets/molecules/pinned_widget.dart';
import 'package:realtimekit_ui/src/widgets/participant_tile/peer_avatar_view.dart';
import 'package:realtimekit_ui/src/widgets/participant_tile/peer_video_view.dart';
import 'package:flutter/material.dart';

class RtkParticipantTile extends StatefulWidget with UiKitElement {
  final RtkMeetingParticipant participant;
  final double height;
  final double width;
  final RtkDesignTokens designToken;

  RtkParticipantTile(
    this.participant, {
    RtkDesignTokens? designToken,
    super.key,
    this.height = 240,
    this.width = 180,
  }) : designToken = designToken ?? globalDesignToken;

  bool get isSelfView => participant.id == rtkMeeting.localUser.id;
  @override
  State<StatefulWidget> createState() => _PeerViewState();

  @override
  double get borderRadius => designToken.borderToken.getRadius(BorderSize.two);

  @override
  double get borderWidth => 0.0;

  @override
  Color get fillColor => designToken.colorToken.backgroundColor.shade900;

  @override
  Color get textColor => designToken.colorToken.textColor.shade1000;
}

class _PeerViewState extends State<RtkParticipantTile> {
  VideoNotifier? _videoNotifier;
  LocalUserVideoNotifier? _localUserVideoNotifier;
  late final bool _isSelfView;

  @override
  void initState() {
    super.initState();
    _isSelfView = widget.isSelfView;

    if (_isSelfView) {
      _localUserVideoNotifier = LocalUserVideoNotifier();
      rtkMeeting.addSelfEventListener(_localUserVideoNotifier!);
    } else {
      _videoNotifier = VideoNotifier(widget.participant);
      rtkMeeting.addParticipantsEventListener(_videoNotifier!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double size = min(124, constraints.smallest.shortestSide * 0.45);
      return Stack(
        children: [
          if (_isSelfView)
            ValueListenableBuilder(
              valueListenable: _localUserVideoNotifier!,
              builder: (context, isVideoEnabled, child) {
                return SizedBox(
                  child: isVideoEnabled
                      ? PeerVideoView(
                          VideoView(
                            isSelfParticipant: true,
                            meetingParticipant: null,
                            key: generateKeyForParticipant(
                              widget.participant,
                              pageName: 'PeerView',
                            ),
                          ),
                          borderRadius: widget.borderRadius,
                        )
                      : PeerAvatarView(
                          widget.participant,
                          backgroundColor: widget.fillColor,
                          borderRadius: widget.borderRadius,
                        ),
                );
              },
            )
          else
            ValueListenableBuilder(
              valueListenable: _videoNotifier!,
              builder: (context, isVideoEnabled, child) {
                return SizedBox(
                  child: isVideoEnabled
                      ? PeerVideoView(
                          VideoView(
                            isSelfParticipant: false,
                            meetingParticipant: widget.participant,
                            key: generateKeyForParticipant(
                              widget.participant,
                              pageName: 'PeerView',
                            ),
                          ),
                          borderRadius: widget.borderRadius,
                        )
                      : PeerAvatarView(
                          widget.participant,
                          backgroundColor: widget.fillColor,
                          borderRadius: widget.borderRadius,
                        ),
                );
              },
            ),
          Positioned(
            left: context.adjust(6),
            top: context.adjust(6),
            child: PinnedWidget(widget.participant),
          ),
          Positioned(
            left: context.adjust(6),
            bottom: context.adjust(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    borderToken.getRadius(BorderSize.one)),
                color: backgroundColorSwatch.shade800,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RtkAudioIndicatorIconWidget(
                    participant: widget.participant,
                    iconSize: context.adjust(14),
                  ),
                  hspace1,
                  RtkNameTag(
                    size: size,
                    color: widget.textColor,
                    participant: widget.participant,
                  ),
                ],
              ),
            ),
          )
        ],
      );
    });
  }

  @override
  void dispose() {
    if (_localUserVideoNotifier != null) {
      rtkMeeting.removeSelfEventListener(_localUserVideoNotifier!);
    }
    if (_videoNotifier != null) {
      rtkMeeting.removeParticipantsEventListener(_videoNotifier!);
    }
    super.dispose();
  }
}
