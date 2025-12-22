import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class ScreenshareView extends StatefulWidget {
  final RtkMeetingParticipant meetingParticipant;
  const ScreenshareView(
    this.meetingParticipant, {
    super.key,
  });

  @override
  State<ScreenshareView> createState() => _ScreenshareViewState();
}

class _ScreenshareViewState extends State<ScreenshareView> {
  Key _generateKeyForMeetingParticipant() {
    return Key('${widget.meetingParticipant.id} screenshare');
  }

  AndroidViewController? androidController;
  UiKitViewController? iosController;

  @override
  Widget build(BuildContext context) {
    const String viewType = 'DytePlatformScreenshareView';
    final Map<String, dynamic> creationParams = {
      'id': widget.meetingParticipant.id,
    };

    final Key key = _generateKeyForMeetingParticipant();

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: LayoutBuilder(builder: (context, constraints) {
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
            return PlatformViewLink(
                key: key,
                viewType: viewType,
                surfaceFactory:
                    (BuildContext context, PlatformViewController controller) {
                  androidController = controller as AndroidViewController;
                  return AndroidViewSurface(
                    controller: androidController!,
                    gestureRecognizers: const <Factory<
                        OneSequenceGestureRecognizer>>{},
                    hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                  );
                },
                onCreatePlatformView: (PlatformViewCreationParams params) {
                  return PlatformViewsService.initSurfaceAndroidView(
                    id: params.id,
                    viewType: viewType,
                    layoutDirection: TextDirection.ltr,
                    creationParams: creationParams,
                    creationParamsCodec: const StandardMessageCodec(),
                  )
                    ..addOnPlatformViewCreatedListener(
                        params.onPlatformViewCreated)
                    ..create();
                });

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
      }),
    );
  }

  @override
  void dispose() {
    androidController?.dispose();
    super.dispose();
  }
}
