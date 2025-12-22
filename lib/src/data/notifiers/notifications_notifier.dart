import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/data/models/notification.dart';
import 'package:realtimekit_ui/src/data/states/notification_state.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/di/di.dart';

class RtkNotificationNotifier extends Notifier<NotificationState>
    implements
        RtkChatEventListener,
        RtkPollsEventListener,
        RtkParticipantsEventListener,
        RtkPluginsEventListener {
  @override
  NotificationState build() {
    return OnNotificationInitial();
  }

  final Set<String> _recentNotifications = {};
  final Set<String> _chatNotificationsId = {};
  final Set<String> _pollNotificationsId = {};

  bool _isNotificationByMe(String userId) =>
      rtkMeeting.localUser.userId == userId;

  bool _isNotificationAlreadyShown(String hashCode) {
    if (!_recentNotifications.contains(hashCode)) {
      _recentNotifications.add(hashCode);
      return false;
    }
    return true;
  }

  bool _isChatNotificationAlreadyShown(ChatMessage message) {
    final chatId = '${message.time}-${message.userId}';
    if (!_chatNotificationsId.contains(chatId)) {
      _chatNotificationsId.add(chatId);
      return false;
    }
    return true;
  }

  bool _isPollNotificationAlreadyShown(Poll poll) {
    if (!_pollNotificationsId.contains(poll.id)) {
      _pollNotificationsId.add(poll.id);
      return false;
    }
    return true;
  }

  void showCustomNotification(String message) {
    if (_isNotificationAlreadyShown(message.hashCode.toString())) return;
    state = OnNewNotificationReceived(
        RtkNotification(message, NotificationType.custom));
  }

  @override
  void onNewChatMessage(ChatMessage message) {
    if (_isNotificationByMe(message.userId) ||
        _isChatNotificationAlreadyShown(message)) {
      return;
    }
    final textMessage = _getFormattedMessage(message);
    state = OnNewNotificationReceived(
        RtkNotification(textMessage, NotificationType.chat));
  }

  @override
  void onNewPoll(Poll poll) {
    if (_isPollNotificationAlreadyShown(poll)) return;
    state = OnNewNotificationReceived(
        RtkNotification(RtkStrings.newPollCreated, NotificationType.poll));
  }

  @override
  void onParticipantJoin(RtkMeetingParticipant participant) {
    if (_isNotificationByMe(participant.id) ||
        _isNotificationAlreadyShown(participant.hashCode.toString())) {
      return;
    }
    state = OnNewNotificationReceived(RtkNotification(
        '${participant.name} joined', NotificationType.participant));
  }

  @override
  void onParticipantLeave(RtkMeetingParticipant participant) {
    if (_isNotificationByMe(participant.id) ||
        _isNotificationAlreadyShown(participant.hashCode.toString())) {
      return;
    }
    state = OnNewNotificationReceived(RtkNotification(
        '${participant.name} left', NotificationType.participant));
  }

  @override
  void onPluginActivated(RtkPlugin plugin) {
    if (_isNotificationAlreadyShown(plugin.hashCode.toString())) return;
    state = OnNewNotificationReceived(
        RtkNotification('${plugin.name} launched', NotificationType.plugin));
  }

  @override
  void onPluginDeactivated(RtkPlugin plugin) {
    if (_isNotificationAlreadyShown(plugin.hashCode.toString())) return;
    state = OnNewNotificationReceived(
        RtkNotification('${plugin.name} closed', NotificationType.plugin));
  }

  String _getFormattedMessage(ChatMessage message) {
    if (message is TextMessage) {
      return '${message.displayName}: ${message.message}';
    } else if (message is ImageMessage) {
      return '${message.displayName}: Image received';
    } else {
      return '${message.displayName}: File received';
    }
  }

  @override
  void onActiveParticipantsChanged(List<RtkRemoteParticipant> active) {}

  @override
  void onAudioUpdate(RtkRemoteParticipant participant, bool isEnabled) {}

  @override
  void onChatUpdates(List<ChatMessage> messages) {}

  @override
  void onParticipantPinned(RtkRemoteParticipant participant) {}

  @override
  void onParticipantUnpinned(RtkRemoteParticipant participant) {}

  @override
  void onPluginFileRequest(RtkPlugin plugin) {}

  @override
  void onPluginMessage(RtkPlugin plugin, String eventName, String data) {}

  @override
  void onUpdate(RtkParticipants participants) {}

  @override
  void onVideoUpdate(RtkRemoteParticipant participant, bool isEnabled) {}

  @override
  void onNewBroadcastMessage(String type, Map<String, dynamic> payload) {
    // TODO: implement onNewBroadcastMessage
  }

  @override
  void onScreenShareUpdate(RtkRemoteParticipant participant, bool isEnabled) {
    // TODO: implement onScreenShareUpdate
  }

  @override
  void onActiveSpeakerChanged(RtkRemoteParticipant? participant) {
    // TODO: implement onActiveSpeakerChanged
  }

  @override
  void onPollUpdates(List<Poll> pollItems) {
    // TODO: implement onPollUpdates
  }

  @override
  void onPollUpdate(Poll poll) {
    // TODO: implement onPollUpdate
  }
}
