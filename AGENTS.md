# realtimekit_core_android

Android platform implementation. Kotlin native code bridging Flutter MethodChannel/EventChannel to the Cloudflare Realtime Android SDK.

## STRUCTURE

```
android/src/main/kotlin/com/cloudflare/realtimekit/flutter/
├── FlutterCorePlugin.kt           # Plugin entry point, registers channels + views
├── Constants.kt                   # Shared constants (channel names, method names)
├── RtkSinkWrapper.kt              # EventChannel.EventSink wrapper for thread-safe event emission
├── ChatFileDownloader.kt          # File download utility for chat attachments
├── methodChannels/
│   └── FlutterCoreMethodChannelHandler.kt  # Handles all MethodChannel calls from Dart
└── view/
    ├── videoview/             # VideoView PlatformView (Factory + View + NativeViewFactory)
    ├── livestream/            # LivestreamView PlatformView
    ├── screenshare/           # ScreenshareView PlatformView
    └── plugin/                # PluginView PlatformView
```

## KEY PATTERNS

- **PlatformView pattern**: Each view has `*Factory` (creates views), `*View` (Android View wrapper), `*NativeViewFactory`
- **Single MethodChannel handler**: All Dart→Native calls routed through `FlutterCoreMethodChannelHandler`
- **EventSink wrapper**: `RtkSinkWrapper` ensures thread-safe event emission to Flutter
- **Dart-side entry**: `lib/realtimekit_core_android.dart` — single file, registers this as the platform implementation

## CONVENTIONS

- Layout XML files in `android/src/main/res/layout/` for each view type
- AGP and Kotlin versions managed in `android/build.gradle`
- `minSdk` and `compileSdk` set in build.gradle, not in Dart code

## WHEN MODIFYING

- New MethodChannel call → add case in `FlutterCoreMethodChannelHandler`, add Dart-side method in platform_interface
- New PlatformView → create Factory + View + NativeViewFactory in `view/`, register in `FlutterCorePlugin`
- New EventChannel → create listener, register in plugin, wrap sink with `RtkSinkWrapper`