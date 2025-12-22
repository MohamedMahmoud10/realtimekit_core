import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';
import 'package:realtimekit_core_platform_interface/src/method_channels/video_view_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';

class VideoView extends StatefulWidget {
  final RtkMeetingParticipant? meetingParticipant;
  final bool isSelfParticipant;
  const VideoView({
    super.key,
    this.meetingParticipant,
    this.isSelfParticipant = false,
  }) : assert(!(meetingParticipant != null && isSelfParticipant));

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  ValueKey<String> _generateKeyForMeetingParticipant() {
    if (widget.isSelfParticipant) {
      return const ValueKey('self_participant_video');
    }
    return ValueKey('participant_video_${widget.meetingParticipant?.id}');
  }

  final VideoViewController _controller = VideoViewController.instance;
  Orientation orientation = Orientation.portrait;

  // will be assigned by the native side
  int? nativeViewId;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation != this.orientation) {
        this.orientation = orientation;
      }
      return FocusDetector(
        onFocusGained: () {
          if (defaultTargetPlatform == TargetPlatform.iOS &&
              widget.isSelfParticipant) {
            setState(() {});
          } else if (nativeViewId != null &&
              defaultTargetPlatform == TargetPlatform.android) {
            _controller.refresh(nativeViewId!);
          }
        },
        child: _buildPlatformViewVirtualDisplayMode(),
      );
    });
  }

  _buildPlatformViewVirtualDisplayMode() {
    const String viewType = 'DytePlatformVideoView';
    final Map<String, dynamic> creationParams = {
      'id': widget.meetingParticipant?.id,
      'isSelfParticipant': widget.isSelfParticipant,
    };

    return LayoutBuilder(
        key: _generateKeyForMeetingParticipant(),
        builder: (context, constraints) {
          switch (defaultTargetPlatform) {
            case TargetPlatform.android:
              return ClipRect(
                child: AndroidView(
                  viewType: viewType,
                  layoutDirection: TextDirection.ltr,
                  creationParams: creationParams,
                  creationParamsCodec: const StandardMessageCodec(),
                  onPlatformViewCreated: (viewId) => nativeViewId = viewId,
                ),
              );

            case TargetPlatform.iOS:
              return ClipRect(
                child: UiKitView(
                  viewType: viewType,
                  layoutDirection: TextDirection.ltr,
                  creationParams: creationParams,
                  creationParamsCodec: const StandardMessageCodec(),
                ),
              );
            default:
              throw UnsupportedError('Unsupported platform view');
          }
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
