# RealtimeKit Flutter UI — Project Knowledge Base

**Generated:** 2026-02-23
**Commit:** f894dc0a
**Branch:** staging

## OVERVIEW

Flutter video-conferencing UI SDK (`realtimekit_ui`) wrapping `realtimekit_core`. Provides pre-built screens for group calls, webinars, and livestreams with customizable design tokens. MVVM architecture using Riverpod + GetIt hybrid DI.

## STRUCTURE

```
flutter-ui/
├── lib/
│   ├── realtimekit_ui.dart    # Public API barrel — all exports go here
│   └── src/
│       ├── data/               # State management (notifiers, states, models)
│       ├── di/                 # Dependency injection (GetIt + Riverpod providers)
│       ├── localization/       # i18n via ARB files
│       ├── pages/              # Full-screen views (room, chat, polls, setup)
│       ├── routes/             # Custom Navigator wrapper + route name constants
│       ├── tokens/             # Design system (color, font, size, space, theme)
│       ├── utils/              # Utilities (key generation, URI resolver)
│       ├── widgets/            # Reusable components (atoms/molecules/core/feature)
│       └── strings.dart        # Localized string accessors
├── example/                    # Demo app (own pubspec, builds APK/IPA)
├── assets/                     # Images + Inter font files
└── .github/workflows/          # CI (pr checks), release (android/ios scheduled)
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Add public widget | `lib/realtimekit_ui.dart` | Export with `show` directive |
| Add new feature state | `lib/src/data/notifiers/` + `states/` | Create Notifier + State class pair |
| Wire new listener | `lib/src/data/manage_listeners.dart` | Register via `rtkMeeting.add*EventListener()` |
| Register provider | `lib/src/di/riverpod_di.dart` | Add `NotifierProvider<T, S>()` |
| Register singleton | `lib/src/di/di.dart` | Add `getIt.register*<T>()` + teardown |
| Add new page/screen | `lib/src/pages/` | ConsumerWidget or ConsumerStatefulWidget |
| Add reusable widget | `lib/src/widgets/atoms/` or `molecules/` | Follow atomic design hierarchy |
| Customize theme | `lib/src/tokens/` | Modify via `RtkDesignTokens` |
| Add route | `lib/src/pages/room_route_page.dart` | Add case to `routerNotifier` listener switch |
| Add localized string | `lib/src/strings.dart` + `localization/app_local.dart` | Static getter pattern |
| CI config | `.github/workflows/ci.yaml` | Runs on PR, builds APK + IPA |

## ARCHITECTURE

```
RealtimekitClient (realtimekit_core — external)
    │ emits events
    ▼
RtkListenerManager.registerRtkListeners()  ← bridges events to Riverpod
    │
    ▼
Notifiers (extend Notifier<T>, implement Rtk*EventListener)
    │ update state
    ▼
State Classes (sealed union variants per feature)
    │ ref.watch()
    ▼
ConsumerWidget / ConsumerStatefulWidget (pages + widgets)
```

**Two DI layers:**
- **GetIt** — singletons: `RealtimekitClient`, `RtkDesignTokens`, `RtkMeetingInfo`, `RtkConfig`, `FontSize`, `ParticipantsNotifier`
- **Riverpod** — reactive providers: 25+ `NotifierProvider`s in `riverpod_di.dart`

**Navigation:** Imperative state-machine in `RoomRoutePage` — listens to `routerNotifier` and pushes screens via `Navigator`. No go_router/auto_route.

## CONVENTIONS

- **Class prefix:** All public classes use `Rtk` prefix (e.g. `RtkText`, `RtkButton`, `RtkParticipantTile`)
- **File naming:** snake_case, public widgets prefixed `rtk_` (e.g. `rtk_text.dart`)
- **Widget hierarchy:** Atomic Design — `atoms/` → `molecules/` → `core/` → feature dirs
- **State pattern:** Notifiers implement `Rtk*EventListener` interfaces from `realtimekit_core`
- **State classes:** Sealed unions with `On{Event}` prefix (e.g. `OnAudioUpdate`, `OnVideoUpdate`)
- **Barrel exports:** Only `lib/realtimekit_ui.dart` — use `show` to limit public surface
- **Design tokens:** Access via `globalDesignToken`, `textColorSwatch`, `brandColorSwatch`, `backgroundColorSwatch` getters in `di.dart`
- **Responsive sizing:** `SizeConfig().init(context)` at root, then `SizeUtil` extension for proportional scaling (375×812 base)
- **Font:** Inter (3 weights: 300/400/700)
- **Theme:** Material 3 via `AppTheme(colorToken).theme`

## ANTI-PATTERNS (THIS PROJECT)

- **NEVER** hardcode colors — use `globalDesignToken.colorToken.*` or theme
- **NEVER** use `StatefulWidget` directly for pages — use `ConsumerStatefulWidget` (Riverpod)
- **NEVER** access `RealtimekitClient` directly in widgets — go through notifiers/providers
- **NEVER** add navigation logic outside `room_route_page.dart` for meeting flow transitions
- **NEVER** register GetIt dependencies outside `di.dart` `setupDependecies()`
- **DO NOT** fix the `respository/` typo without coordinating — it's referenced in imports
- **DO NOT** fix `setupDependecies` typo — same reason

## KNOWN DEBT

- 46+ TODO comments (unimplemented event handlers, AppTheme migration, Riverpod removal in pinned_widget)
- `status_color.dart` marked for removal
- `respository/` directory typo (should be `repository/`)
- `setupDependecies` method typo (should be `setupDependencies`)
- Plugin functionality blocked by mobile-core release
- Multiple widgets still using hardcoded colors instead of `AppTheme`

## COMMANDS

```bash
# Dev
flutter pub get
flutter run                      # Run example app

# Build
sh build.sh                      # clean + build_runner
sh clean.sh                      # flutter clean + pub get
sh format.sh                     # format

# Example app
cd example && flutter build apk  # Android
cd example && flutter build ios  # iOS (requires codesign)

# CI runs on PR: builds APK + IPA on macos-26 with Flutter 3.38.6
```

## NOTES

- Package version in pubspec.yaml must be coordinated with `main` branch (version regression risk)
- Example app requires `lib/secrets.dart` with `participantAuthToken` — CI generates it, gitignored
- `.gitignore` has `secret.dart` but CI generates `secrets.dart` (plural) — mismatch
- iOS deployment target is aggressive (26.0 in example)
- Library claims Dart >=2.19.0 support but only CI-tested on 3.38.x
- Three meeting room types: `RtkGCMeetingRoom` (group call), `RtkWebinarMeetingRoom`, `RtkLivestreamMeetingRoom`

# RealtimeKit UI — Flutter Video Conferencing SDK

**Package**: `realtimekit_ui` v0.2.0
**Core dep**: `realtimekit_core` (provides `RealtimekitClient`, event listeners, data models)
**Stack**: Flutter 3.38.x · Dart >=2.19 · Riverpod 2.x · GetIt 9.x · Material 3

## STRUCTURE
```
lib/
├── realtimekit_ui.dart        # Public barrel — ALL exports here
└── src/
    ├── rtk_app.dart            # RealtimeKitUIBuilder + RealtimeKitUI + RtkProvider
    ├── strings.dart             # Localized string accessors
    ├── data/                    # State layer (see data/AGENTS.md)
    │   ├── notifiers/           # 23 Riverpod notifiers (implement core listeners)
    │   ├── states/              # State sealed classes per feature
    │   ├── models/              # UI data models
    │   ├── respository/         # GridNotifier (NOTE: typo in dirname)
    │   ├── manage_listeners.dart # Bridges RealtimekitClient events → notifiers
    │   └── provider_logger.dart
    ├── widgets/                 # Atomic Design components (see widgets/AGENTS.md)
    │   ├── atoms/               # Base: RtkText, RtkButton, RtkTextField...
    │   ├── molecules/           # Composite: control bars, device selectors...
    │   ├── core/                # Base classes: RtkUIKitComponent, button system
    │   └── [feature]/           # Feature widgets: participant_tile, audio_toggle...
    ├── pages/                   # Full screens (see pages/AGENTS.md)
    │   ├── room/                # Meeting rooms (GC, Webinar, Livestream) + grid
    │   ├── chats/               # Chat page + widgets
    │   ├── polls/               # Polls page + widgets
    │   ├── participants/        # Participant list
    │   └── setup/               # Pre-join setup screen
    ├── tokens/                  # Design system tokens
    │   ├── theme.dart           # AppTheme → Material 3 ThemeData
    │   ├── color/               # Color swatches + status colors
    │   ├── font/                # Inter font family, FontSize tokens
    │   ├── size/                # SizeConfig, SizeUtil, responsive scaling (375×812 base)
    │   └── space/               # Spacing tokens
    ├── di/
    │   ├── di.dart              # GetIt: singletons (client, config, design tokens)
    │   └── riverpod_di.dart     # 28 NotifierProviders — ALL providers defined here
    ├── routes/                  # Custom Navigator wrapper (no GoRouter)
    ├── localization/            # ARB-based i18n
    └── utils/                   # Key generation, URI resolution
example/                         # Demo app (own pubspec, path-depends on ../)
```

## WHERE TO LOOK
| Task | Location |
|------|----------|
| Add public API export | `lib/realtimekit_ui.dart` |
| Add new feature state | `lib/src/data/notifiers/` + `lib/src/data/states/` + wire in `manage_listeners.dart` + register in `riverpod_di.dart` |
| Add new widget | `lib/src/widgets/atoms/` or `molecules/` or new feature dir |
| Add new page/screen | `lib/src/pages/` + add route in `room_route_page.dart` |
| Modify theme/colors | `lib/src/tokens/` + `lib/src/di/di.dart` globals |
| Change DI registrations | `lib/src/di/di.dart` (GetIt) or `lib/src/di/riverpod_di.dart` (Riverpod) |
| Customize localization | `lib/src/strings.dart` + `lib/src/localization/` |

## ARCHITECTURE

**Pattern**: MVVM + Event-Driven. No repository layer — `RealtimekitClient` IS the data source.

```
RealtimekitClient (from realtimekit_core)
  │ emits events via listener interfaces
  ▼
RtkListenerManager.registerRtkListeners()  ← bridges events to Riverpod
  │ notifiers implement RtkSelfEventListener, RtkChatEventListener, etc.
  ▼
Riverpod Notifiers (23 notifiers in data/notifiers/)
  │ update typed state classes
  ▼
State Classes (data/states/)  ← sealed unions for pattern matching
  │ ref.watch() in UI
  ▼
ConsumerWidget / ConsumerStatefulWidget
```

**Dual DI**: GetIt for static singletons (client, config, tokens). Riverpod for reactive state.

**Navigation**: State-machine in `room_route_page.dart`. `routerNotifier` emits state → switch on `runtimeType` → `Navigator.push/pushReplacement`. No GoRouter.

## CONVENTIONS

- **Prefix all public classes** with `Rtk` (e.g., `RtkText`, `RtkButton`, `RtkParticipantTile`)
- **Notifier naming**: `{Feature}Notifier` (e.g., `ChatListNotifier`, `RecordingNotifer`)
- **State naming**: `On{Event}` variants in sealed class (e.g., `OnAudioUpdate`, `OnVideoUpdate`)
- **File naming**: `snake_case`, public widgets prefixed `rtk_` (e.g., `rtk_button.dart`)
- **Imports**: package imports first → Flutter SDK → relative. Use `package:realtimekit_ui/...` not relative for cross-src imports.
- **Design tokens via DI**: Never hardcode colors/sizes. Use `globalDesignToken`, `textColorSwatch`, `backgroundColorSwatch`, `fontSize` from `di.dart`.
- **Barrel exports**: Only in `realtimekit_ui.dart`. Use `show` to limit public API surface.
- **Widget types**: Atoms = StatelessWidget. Molecules/pages = ConsumerWidget or ConsumerStatefulWidget.

## ANTI-PATTERNS (THIS PROJECT)

- **DO NOT** use `go_router` or any routing package — navigation is state-driven via `routerNotifier`
- **DO NOT** register new GetIt dependencies without corresponding `tearDownDependencies` cleanup
- **DO NOT** hardcode colors — always use token system (`globalDesignToken.colorToken`, `backgroundColorSwatch`, etc.)
- **DO NOT** add Riverpod providers outside `riverpod_di.dart` — ALL providers are centralized there
- **DO NOT** listen to `RealtimekitClient` events directly in widgets — go through notifiers via `manage_listeners.dart`

## KNOWN ISSUES

- `respository/` directory is misspelled (should be `repository/`)
- 46 TODOs including unimplemented stage event handlers, incomplete AppTheme migration
- `status_color.dart` marked for removal (`@Saksham we need to remove this file`)
- Plugin functionality blocked by mobile-core release
- Some notifiers have typos: `LocalUserNotifer`, `RecordingNotifer`, `PluginNotifer` (missing 'i')

## COMMANDS
```bash
# Build (from root)
flutter pub get
sh build.sh              # clean + build_runner

# Example app
cd example && flutter pub get && flutter run

# CI validates (on PR)
# - APK build (example/)
# - iOS archive (example/)
# Flutter 3.38.6 pinned in CI
```

## NOTES

- `RealtimeKitUIBuilder.build()` is the main entry — registers DI, returns widget
- Three meeting types: `groupCall`, `webinar`, `livestream` — each has own room widget
- `RtkProvider` wraps entire app in `ProviderScope` + `Theme` — must be ancestor of all Rtk widgets
- Font: Inter (bundled in assets/fonts/)
- Responsive sizing uses 375×812 base via `SizeUtil.adjust()`
- Localization: single-locale ARB, controlled via `RtkStrings.locale`