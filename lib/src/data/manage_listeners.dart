import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/di/di.dart';

class RtkListenerManager {
  final WidgetRef ref;

  RtkListenerManager._(this.ref);

  static late RtkListenerManager? _instance;

  static void init(WidgetRef ref) {
    _instance = RtkListenerManager._(ref);
  }

  static RtkListenerManager get instance {
    assert(_instance != null,
        'ManageListener not initialized, please call init()');
    return _instance!;
  }

  void registerRtkListeners() {
    rtkMeeting.addMeetingRoomEventListener(
      ref.read(routerNotifier.notifier),
    );
    rtkMeeting.addSelfEventListener(
      ref.read(localUserSettingsProvider.notifier),
    );
    rtkMeeting.addSelfEventListener(
      ref.read(routerNotifier.notifier),
    );
    rtkMeeting.addParticipantsEventListener(
      ref.read(participantEventNotifier.notifier),
    );

    rtkMeeting.addChatEventListener(
      ref.read(chatListNotifier.notifier),
    );
    rtkMeeting.addParticipantsEventListener(
      ref.read(gridNotifier.notifier),
    );

    rtkMeeting.addDataUpdateEventListener(
      ref.read(screenshareProvider.notifier),
    );
    rtkMeeting.addRecordingEventListener(
      ref.read(recordingNotifier.notifier),
    );
    rtkMeeting.addDataUpdateEventListener(
      ref.read(pluginProvider.notifier),
    );
    rtkMeeting.addWaitlistEventListener(
      ref.read(waitingRoomNotifier.notifier),
    );
    rtkMeeting.addPollsEventListener(
      ref.read(newPollEventNotifier.notifier),
    );
    rtkMeeting.addPollsEventListener(
      ref.read(pollsListNotifier.notifier),
    );
    rtkMeeting.addPollsEventListener(
      ref.read(unreadPollsNotifier.notifier),
    );
    rtkMeeting.addChatEventListener(
      ref.read(unreadChatNotifier.notifier),
    );

    rtkMeeting.addWaitlistEventListener(
      ref.read(unreadWaitlistedCountNotifier.notifier),
    );

    rtkMeeting.addStageEventListener(
      ref.read(unreadStageRequestCountNotifier.notifier),
    );

    // For notifications across the SDK
    rtkMeeting.addChatEventListener(
      ref.read(notificationProvider.notifier),
    );
    rtkMeeting.addPollsEventListener(
      ref.read(notificationProvider.notifier),
    );
    rtkMeeting.addParticipantsEventListener(
      ref.read(notificationProvider.notifier),
    );
    rtkMeeting.addPluginsEventListener(
      ref.read(notificationProvider.notifier),
    );
    rtkMeeting.addLivestreamEventListener(
      ref.read(lvsStateNotifier.notifier),
    );
    rtkMeeting.addStageEventListener(
      ref.read(stageStatusNotifier.notifier),
    );
    rtkMeeting.addStageEventListener(
      ref.read(stageRequestsNotifier.notifier),
    );

    rtkMeeting.addSelfEventListener(
      ref.read(selfScreenshareProvider.notifier),
    );

    rtkMeeting.addStageEventListener(
      ref.read(participantsProvider.notifier),
    );
  }

  void unregisterRtkListeners() {
    rtkMeeting.removeSelfEventListener(
      ref.read(localUserSettingsProvider.notifier),
    );
    ref.invalidate(localUserSettingsProvider);

    rtkMeeting.removeSelfEventListener(
      ref.read(routerNotifier.notifier),
    );
    ref.invalidate(routerNotifier);

    rtkMeeting.removeParticipantsEventListener(
      ref.read(participantEventNotifier.notifier),
    );
    ref.invalidate(participantEventNotifier);

    rtkMeeting.removeChatEventListener(
      ref.read(chatListNotifier.notifier),
    );
    ref.invalidate(chatListNotifier);

    rtkMeeting.removeParticipantsEventListener(
      ref.read(gridNotifier.notifier),
    );
    ref.invalidate(gridNotifier);

    rtkMeeting.removeDataUpdateEventListener(
      ref.read(screenshareProvider.notifier),
    );
    ref.invalidate(screenshareProvider);

    rtkMeeting.removeRecordingEventListener(
      ref.read(recordingNotifier.notifier),
    );
    ref.invalidate(recordingNotifier);

    rtkMeeting.removeDataUpdateEventListener(
      ref.read(pluginProvider.notifier),
    );
    ref.invalidate(pluginProvider);

    rtkMeeting.removeWaitlistEventListener(
      ref.read(waitingRoomNotifier.notifier),
    );
    ref.invalidate(waitingRoomNotifier);

    rtkMeeting.removePollsEventListener(
      ref.read(newPollEventNotifier.notifier),
    );
    ref.invalidate(newPollEventNotifier);

    rtkMeeting.removePollsEventListener(
      ref.read(pollsListNotifier.notifier),
    );
    ref.invalidate(pollsListNotifier);

    rtkMeeting.removePollsEventListener(
      ref.read(unreadPollsNotifier.notifier),
    );
    ref.invalidate(unreadPollsNotifier);

    rtkMeeting.removeChatEventListener(
      ref.read(unreadChatNotifier.notifier),
    );
    ref.invalidate(unreadChatNotifier);

    rtkMeeting.removeWaitlistEventListener(
      ref.read(unreadWaitlistedCountNotifier.notifier),
    );
    ref.invalidate(unreadWaitlistedCountNotifier);

    rtkMeeting.removeStageEventListener(
      ref.read(unreadStageRequestCountNotifier.notifier),
    );
    ref.invalidate(unreadStageRequestCountNotifier);

    // For notifications across the SDK
    rtkMeeting.removeChatEventListener(
      ref.read(notificationProvider.notifier),
    );
    rtkMeeting.removePollsEventListener(
      ref.read(notificationProvider.notifier),
    );
    rtkMeeting.removeParticipantsEventListener(
      ref.read(notificationProvider.notifier),
    );
    rtkMeeting.removePluginsEventListener(
      ref.read(notificationProvider.notifier),
    );
    ref.invalidate(notificationProvider);

    rtkMeeting.removeLivestreamEventListener(
      ref.read(lvsStateNotifier.notifier),
    );
    ref.invalidate(lvsStateNotifier);

    rtkMeeting.removeStageEventListener(
      ref.read(stageStatusNotifier.notifier),
    );
    rtkMeeting.removeStageEventListener(
      ref.read(stageRequestsNotifier.notifier),
    );
    ref.invalidate(stageStatusNotifier);

    rtkMeeting.removeSelfEventListener(
      ref.read(selfScreenshareProvider.notifier),
    );
    ref.invalidate(selfScreenshareProvider);

    rtkMeeting.removeStageEventListener(
      ref.read(participantsProvider.notifier),
    );
    ref.invalidate(participantsProvider);
  }
}
