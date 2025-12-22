import 'package:flutter/services.dart';

class VideoViewController {
  VideoViewController._();

  static final instance = VideoViewController._();

  final _channel =
      const MethodChannel('realtimekit_core/video_view#refreshVideo');

  void refresh(int viewId) {
    _channel.invokeMethod('refreshVideoView', {
      'viewId': viewId,
    });
  }
}
