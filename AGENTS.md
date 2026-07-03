# realtimekit_core

Thin wrapper around `realtimekit_core_platform_interface`. Sole public class: `RealtimekitClient`.

## STRUCTURE

```
realtimekit_core/
├── lib/
│   ├── realtimekit_core.dart           # Barrel file — re-exports 85+ symbols from platform_interface
│   └── src/realtimekit_core.dart        # RealtimekitClient implementation
└── example/                             # Manual test app (Android + iOS)
    └── lib/main.dart
```

## HOW IT WORKS

- `RealtimekitClient` delegates ALL operations to `RtkClientPlatform.instance` via `_platform` getter
- Lifecycle: `init(RtkMeetingInfo)` → `joinRoom()` → `leaveRoom()` → `cleanAllNativeListeners()`
- Listener management: `add*EventListener()` / `remove*EventListener()` / `cleanNative*Listener()` for 10 domains
- Properties: `participants`, `localUser`, `meta`, `chat`, `polls`, `recording`, `livestream`, `stage`, `plugins`, `permissions`
- `RtkBase64Encoding.auth()` — helper for org+apiKey basic auth encoding
- On init, reads own `pubspec.yaml` via `rootBundle` to send SDK version info to native

## CONVENTIONS

- Barrel file uses explicit `show` directives for every symbol — never `export` without `show`
- Also re-exports `Pubspec` from `pubspec_parse` and error types from platform_interface `src/` paths
- Example app is included in Melos workspace (`realtimekit_core/example`)

## WHEN MODIFYING

- Adding a new listener domain → add `add*`, `remove*`, `cleanNative*` methods here delegating to `_platform`
- Exposing a new type → add to barrel file with explicit `show`
- New platform API → add method in `RealtimekitClient` delegating to `_platform`