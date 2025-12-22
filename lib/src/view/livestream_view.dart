import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LivestreamView extends StatelessWidget {
  final String url;
  const LivestreamView(this.url, {super.key});
  int generateRandomId() {
    final random = Random();
    return random.nextInt(100000);
  }

  @override
  Widget build(BuildContext context) {
    const String viewType = 'DytePlatformLivestreamView';
    final Map<String, dynamic> creationParams = {
      'url': url,
    };
    return LayoutBuilder(
        key: Key(generateRandomId().toString()),
        builder: (context, constraints) {
          switch (defaultTargetPlatform) {
            case TargetPlatform.android:
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRect(
                  child: AndroidView(
                    viewType: viewType,
                    layoutDirection: TextDirection.ltr,
                    creationParams: creationParams,
                    creationParamsCodec: const StandardMessageCodec(),
                  ),
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
}
