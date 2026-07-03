# Data Layer — Notifiers, States, Models

## OVERVIEW

Event-driven state management layer bridging `realtimekit_core` events to Riverpod providers. 23 notifiers, 10 state files, 4 models.

## STRUCTURE

```
data/
├── notifiers/           # 23 Riverpod Notifier classes (implement Rtk*EventListener)
├── states/              # 10 sealed state class files (union variants per feature)
├── models/              # 4 data models (media toggle, notification, tab participant)
├── respository/         # 1 file: GridNotifier (NOTE: directory name typo is intentional)
├── manage_listeners.dart  # Wires notifiers to RealtimekitClient event listeners
└── provider_logger.dart   # Riverpod ProviderObserver for debug logging
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Add new feature | Create `{feature}_notifier.dart` + `{feature}_states.dart` | Follow existing pattern |
| Wire events | `manage_listeners.dart` | `rtkMeeting.add*EventListener(ref.read(provider.notifier))` |
| Register provider | `../di/riverpod_di.dart` | `NotifierProvider<T, S>(T.new)` |
| Add state variants | `states/{feature}_states.dart` | Extend base state class |
| Track unread counts | Create `Unread{Feature}Notifier` | See `unread_chat_notifier` pattern |

## HOW TO ADD A NEW FEATURE

1. Create `notifiers/{feature}_notifier.dart`:
   - Extend `Notifier<{Feature}States>` (Riverpod)
   - Implement relevant `Rtk*EventListener` interface from `realtimekit_core`
   - Override event callbacks to emit new state variants
2. Create `states/{feature}_states.dart`:
   - Base class (e.g. `{Feature}States`)
   - Concrete variants: `{Feature}StateInitial`, `On{Event}`, etc.
3. Register provider in `../di/riverpod_di.dart`:
   ```dart
   final {feature}Notifier = NotifierProvider<{Feature}Notifier, {Feature}States>(
     {Feature}Notifier.new,
     name: '{feature}Notifier',
   );
   ```
4. Wire listener in `manage_listeners.dart`:
   ```dart
   rtkMeeting.add{Domain}EventListener(ref.read({feature}Notifier.notifier));
   ```
   AND add symmetric `remove*EventListener` + `ref.invalidate()` in `unregisterRtkListeners()`

## NOTIFIER CATEGORIES

| Category | Notifiers | Listener Interface |
|----------|-----------|-------------------|
| Local user | `local_user_notifier`, `edit_name_notifier` | `RtkSelfEventListener` |
| Participants | `participants_notifier`, `participant_state_notifier` | `RtkParticipantsEventListener`, `RtkStageEventListener` |
| Media | `audio_notifier`, `video_notifier`, `screenshare_notifier` | `RtkSelfEventListener`, `RtkDataUpdateEventListener` |
| Chat | `chat_notifier`, `chat_action_notifier` | `RtkChatEventListener` |
| Polls | `poll_notifier`, `poll_option_selector_notifier` | `RtkPollsEventListener` |
| Recording | `recording_notifier` | `RtkRecordingEventListener` |
| Plugins | `plugin_notifier`, `plugin_state_notifier` | `RtkDataUpdateEventListener`, `RtkPluginsEventListener` |
| Stage | `stage_notifier`, `stage_permission_notifier` | `RtkStageEventListener` |
| Livestream | `livestream_notifier` | `RtkLivestreamEventListener` |
| Navigation | `router_notifier` | `RtkMeetingRoomEventListener`, `RtkSelfEventListener` |
| Layout | `grid_notifier` (in respository/), `rtk_tab_notifier` | `RtkParticipantsEventListener` |
| Waiting room | `waitlisted_participant_notifier` | `RtkWaitlistEventListener` |
| Notifications | `notifications_notifier` | Multiple: chat, polls, participants, plugins |
| Timer | `meeting_timer_notifier` | `AutoDisposeNotifierProvider` (no listener) |
| Pin | `pin_unpin_notifier` | Direct method calls (no listener) |

## CONVENTIONS

- Notifier class names: `{Feature}Notifier` or `{Feature}Notifer` (typo exists in codebase, be consistent with neighbors)
- State class names: Base `{Feature}States`, variants `On{Event}` or `{Feature}State{Variant}`
- `StreamNotifierProvider` only for `ParticipantsNotifier` — all others use `NotifierProvider`
- `AutoDisposeNotifierProvider` only for `meetingTimeProvider` — all others are kept alive
- Unread counters: separate `Unread{Feature}Notifier extends Notifier<int>` pattern
- `manage_listeners.dart`: registration and unregistration MUST be symmetric
