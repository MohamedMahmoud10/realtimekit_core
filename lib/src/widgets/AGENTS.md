# Widgets — Atomic Design Component Library

## OVERVIEW

Reusable UI components following Atomic Design: atoms → molecules → core → feature-specific. All public widgets use `Rtk` prefix.

## STRUCTURE

```
widgets/
├── atoms/                  # 14 base components (RtkText, RtkButton, RtkTextField, ...)
├── molecules/              # 13 composite components (control bar, device selectors, snackbar)
│   └── control_bar/        # Meeting control bars (audio/video/more/leave)
├── core/                   # Base abstractions
│   ├── rtk_uikit_component.dart  # Base UIKit component class
│   └── button/             # Button system (controller, elevated, variants)
├── participant_tile/       # Video tile: avatar, video view, peer views
├── audio_toggle/           # Self audio mute/unmute
├── video_toggle/           # Self video on/off
├── leave_button/           # Leave meeting button + confirmation dialog
├── join_button/            # Join meeting button
├── meeting_title/          # Meeting title display
├── rtk_audio_indicator/    # Audio level animation
├── rtk_name_tag/           # Name overlay on tiles
├── chats/                  # Chat icon with unread badge
├── participants_icon/      # Participant count icon
├── plugins_icon/           # Plugins icon with badge
├── polls_icon/             # Polls icon with badge
├── release_resources_button/ # Cleanup resources button
└── utils/                  # Helper: clean_pop.dart (safe navigator pop)
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Simple display widget | `atoms/` | Stateless, theme-aware, no business logic |
| Composed widget | `molecules/` | Combines atoms, may have local state |
| Badge/icon with count | `*_icon/` dirs | Pattern: watch unread provider, show badge |
| Media toggle | `audio_toggle/` or `video_toggle/` | Pattern: call `rtkMeeting.localUser.*` |
| Meeting control bar | `molecules/control_bar/` | `RtkControlBars` with factory constructors per meeting type |

## WIDGET CREATION RULES

1. **Naming:** `Rtk{WidgetName}` class in `rtk_{widget_name}.dart`
2. **Layer placement:**
   - Pure display, no composition → `atoms/`
   - Composes 2+ atoms or has interaction logic → `molecules/`
   - Single-feature widget (own dir) → `{feature_name}/`
3. **State access:** Use `ConsumerWidget` (not `StatefulWidget`) when reading providers
4. **Theme:** Get colors from `Theme.of(context).colorScheme` or `globalDesignToken` — NEVER hardcode
5. **Sizing:** Use `SizeUtil` extension (`context.adjust()`) for responsive values
6. **Spacing:** Use predefined spacers from `atoms/vh_space.dart` (`vspace4`, `hspace4`, etc.)
7. **Strings:** Use `RtkStrings.{key}` — never hardcode user-facing text
8. **Export:** If public API, add to `lib/realtimekit_ui.dart` with `show` directive

## ATOM CONVENTIONS

- Wrap Flutter primitives (Text→RtkText, TextButton→RtkTextButton, etc.)
- Accept style overrides via parameters, fall back to theme
- No provider access (pure presentation)
- Message layouts: `rtk_text_message_layout.dart`, `rtk_image_message_layout.dart`, `rtk_file_message_layout.dart`

## MOLECULE CONVENTIONS

- Compose atoms + add interaction
- Device selectors (`audio_devices_loader`, `video_devices_loader`) load devices from `rtkMeeting`
- `RtkSnackbar` wraps BottomSheet — used for notifications across the SDK
- `PageIndicator` — dot indicator for paged views
- `PinnedWidget` — displays pinned participant (NOTE: marked TODO to remove Riverpod dependency)

## ICON BADGE PATTERN

All feature icons (`chats/`, `polls_icon/`, `participants_icon/`, `plugins_icon/`) follow:
```dart
class Rtk{Feature}IconWidget extends ConsumerWidget {
  // Watch unread count provider
  final count = ref.watch(unread{Feature}Notifier);
  // Return icon with optional badge showing count
}
```
