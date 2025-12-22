import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:realtimekit_ui/src/data/models/rtk_selected_tab_participant.dart';
import 'package:realtimekit_ui/src/data/notifiers/chat_notifier.dart';
import 'package:realtimekit_ui/src/data/notifiers/chat_action_notifier.dart';
import 'package:realtimekit_ui/src/data/notifiers/edit_name_notifier.dart';
import 'package:realtimekit_ui/src/data/notifiers/livestream_notifier.dart';
import 'package:realtimekit_ui/src/data/notifiers/local_user_notifier.dart';
import 'package:realtimekit_ui/src/data/notifiers/meeting_timer_notifier.dart';
import 'package:realtimekit_ui/src/data/notifiers/notifications_notifier.dart';
import 'package:realtimekit_ui/src/data/notifiers/participant_state_notifier.dart';
import 'package:realtimekit_ui/src/data/notifiers/participants_notifier.dart';
import 'package:realtimekit_ui/src/data/notifiers/plugin_state_notifier.dart';
import 'package:realtimekit_ui/src/data/notifiers/poll_notifier.dart';
import 'package:realtimekit_ui/src/data/notifiers/recording_notifier.dart';
import 'package:realtimekit_ui/src/data/notifiers/router_notifier.dart';
import 'package:realtimekit_ui/src/data/notifiers/rtk_tab_notifier.dart';
import 'package:realtimekit_ui/src/data/notifiers/screenshare_notifier.dart';
import 'package:realtimekit_ui/src/data/notifiers/stage_notifier.dart';
import 'package:realtimekit_ui/src/data/notifiers/stage_permission_notifier.dart';
import 'package:realtimekit_ui/src/data/notifiers/waitlisted_participant_notifier.dart';
import 'package:realtimekit_ui/src/data/respository/grid_notifier.dart';
import 'package:realtimekit_ui/src/data/states/livestream_states.dart';
import 'package:realtimekit_ui/src/data/states/local_user_states.dart';
import 'package:realtimekit_ui/src/data/states/notification_state.dart';
import 'package:realtimekit_ui/src/data/states/participant_event_states.dart';
import 'package:realtimekit_ui/src/data/states/poll_states.dart';
import 'package:realtimekit_ui/src/data/states/router_states.dart';
import 'package:realtimekit_ui/src/data/states/waitlisted_participant_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/di/di.dart';

final localUserSettingsProvider =
    NotifierProvider<LocalUserNotifer, LocalUserStates>(
  () {
    return LocalUserNotifer();
  },
  name: 'localUserSettingsProvider',
);

final participantEventNotifier =
    NotifierProvider<ParticipantNotifier, ParticipantEventStates>(
  () => ParticipantNotifier(),
  name: 'participantEventNotifier',
);

final gridNotifier = NotifierProvider<GridNotifier, GridPagesInfo>(
  () => GridNotifier(),
  name: 'gridNotifier',
);

final screenshareProvider =
    NotifierProvider<RemoteScreenshareNotifier, List<RtkMeetingParticipant>>(
        RemoteScreenshareNotifier.new);

final selfScreenshareProvider = NotifierProvider<SelfScreenshareNotifier, bool>(
    SelfScreenshareNotifier.new);

final pluginProvider =
    NotifierProvider<PluginNotifer, List<RtkPlugin>>(PluginNotifer.new);

final chatListNotifier = NotifierProvider<ChatListNotifier, List<ChatMessage>>(
  ChatListNotifier.new,
);

final unreadChatNotifier = NotifierProvider<UnreadChatNotifier, int>(
  UnreadChatNotifier.new,
);

final chatActionNotifierProvider = NotifierProvider<ChatActionNotifier, void>(
  ChatActionNotifier.new,
  name: 'chatActionNotifierProvider',
);

final tabNotifierProvider =
    NotifierProvider<RtkTabNotifier, RtkSelectedTabParticipant>(
  RtkTabNotifier.new,
);

final recordingNotifier =
    NotifierProvider<RecordingNotifer, RecordingState>(RecordingNotifer.new);
final waitingRoomNotifier =
    NotifierProvider<WaitingRoomNotifer, WaitlistedParticipantStates>(
        () => WaitingRoomNotifer());

final routerNotifier = NotifierProvider<RouterNotifier, RouterStates>(
  () => RouterNotifier(),
);

final newPollEventNotifier = NotifierProvider<NewPollNotifer, PollStates>(
  () => NewPollNotifer(),
);

final pollsListNotifier =
    NotifierProvider<PollListNotifier, List<Poll>>(PollListNotifier.new);

final unreadPollsNotifier = NotifierProvider<UnreadPollNotifier, int>(
  () => UnreadPollNotifier(),
);

final unreadWaitlistedCountNotifier =
    NotifierProvider<UnreadWaitlistedCountNotifier, int>(
  UnreadWaitlistedCountNotifier.new,
);

final unreadStageRequestCountNotifier =
    NotifierProvider<UnreadStageRequestsCountNotifier, int>(
  UnreadStageRequestsCountNotifier.new,
);

final meetingTimeProvider =
    AutoDisposeNotifierProvider<RtkMeetingNotifier, Duration?>(
  RtkMeetingNotifier.new,
  name: 'meetingTimeProvider',
);

final notificationProvider =
    NotifierProvider<RtkNotificationNotifier, NotificationState>(
  RtkNotificationNotifier.new,
  name: 'notificationProvider',
);

final editNameProvider = NotifierProvider<EditNameNotifier, String>(
    EditNameNotifier.new,
    name: 'editNameProvider');

final lvsStateNotifier = NotifierProvider<LvsStateNotifier, RtkLivestreamState>(
  LvsStateNotifier.new,
  name: 'lvsStateNotifier',
);

final stageStatusNotifier = NotifierProvider<StageStatusNotifier, StageStatus>(
  StageStatusNotifier.new,
  name: 'stageStatusNotifier',
);

final stageRequestsNotifier =
    NotifierProvider<StageRequestsNotifier, List<RtkRemoteParticipant>>(
  StageRequestsNotifier.new,
  name: 'stageRequestsNotifier',
);

final stagePermissionNotifier =
    NotifierProvider<StagePermissionNotifier, MediaPermission>(
  StagePermissionNotifier.new,
  name: 'stagePermissionNotifier',
);

final participantsProvider =
    StreamNotifierProvider<ParticipantsNotifier, ParticipantsState>(
  () => participantNotifier,
);
