# realtimekit_core_ios

iOS platform implementation. Swift native code bridging Flutter MethodChannel/EventChannel to the Cloudflare Realtime iOS SDK.

## STRUCTURE

```
ios/realtimekit_core_ios/Sources/realtimekit_core_ios/
├── SwiftFlutterCoreIosPlugin.swift   # Plugin entry point, registers channels + views
├── Constants.swift                  # Shared constants (channel names, method names)
├── CallDetailsBuilder.swift         # Builder for call detail objects
├── PrivacyInfo.xcprivacy            # Apple privacy manifest
├── controllers/                     # Native controller wrappers
├── listeners/                       # 13 files: native event listeners
│   ├── RtkEventsHandler.swift          # Coordinator for all event listeners
│   ├── ChatEventsListener.swift
│   ├── ParticipantEventListener.swift
│   ├── ParticipantUpdateEvents.swift
│   ├── SelfParticipantListener.swift
│   ├── RoomEventListeners.swift
│   ├── StageEventsListener.swift
│   ├── PollsEventsListener.swift
│   ├── RecordingEventsListener.swift
│   ├── LivestreamEventsListener.swift
│   ├── PluginEventsListener.swift
│   ├── DataUpdateListener.swift
│   └── WaitingRoomEventsListener.swift
├── models/                          # Native data model wrappers
└── view/                            # 8 files: PlatformView implementations
    ├── RtkVideoView.swift + RtkVideoViewFactory.swift
    ├── RtkLivestreamView.swift + RtkLivestreamViewFactory.swift
    ├── RtkScreenshareView.swift + RtkScreenshareViewFactory.swift
    └── RtkPluginView.swift + RtkPluginViewFactory.swift
```

## KEY PATTERNS

- **View + Factory pattern**: Each PlatformView has a `Rtk*View` (UIView wrapper) + `Rtk*ViewFactory` (FlutterPlatformViewFactory)
- **RtkEventsHandler**: Central coordinator that sets up and manages all native event listeners
- **Swift Package Manager**: iOS native code is managed via SPM (not CocoaPods), configured in `Package.swift`
- **Dart-side entry**: `lib/realtimekit_core_ios.dart` — single file, registers this as the platform implementation

## CONVENTIONS

- iOS minimum deployment target: 12.0
- Privacy manifest (`PrivacyInfo.xcprivacy`) required for App Store compliance
- Uses Swift concurrency patterns where applicable

## WHEN MODIFYING

- New event listener → create `*EventsListener.swift` in `listeners/`, wire up in `RtkEventsHandler`
- New PlatformView → create View + Factory pair in `view/`, register in `SwiftFlutterCoreIosPlugin`
- New model → add to `models/` directory