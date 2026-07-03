import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:flutter/material.dart';

class PeerVideoView extends StatelessWidget {
  const PeerVideoView(
    this.videoView, {
    super.key,
    this.borderRadius = double.maxFinite,
  });
  final VideoView videoView;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: videoView,
    );
  }
}
