import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PluginView extends StatefulWidget {
  final RtkPlugin plugin;
  const PluginView(
    this.plugin, {
    super.key,
  });

  @override
  State<PluginView> createState() => _PluginViewState();
}

class _PluginViewState extends State<PluginView> {
  Key _generateKeyForMeetingParticipant() {
    return Key('${widget.plugin.id} plugin');
  }

  @override
  Widget build(BuildContext context) {
    const String viewType = 'DytePlatformPluginView';
    final Map<String, dynamic> creationParams = {
      'id': widget.plugin.id,
    };
    return LayoutBuilder(builder: (context, constraints) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          return AndroidView(
            key: _generateKeyForMeetingParticipant(),
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
          );

        case TargetPlatform.iOS:
          return ClipRect(
            child: UiKitView(
              key: _generateKeyForMeetingParticipant(),
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
}
