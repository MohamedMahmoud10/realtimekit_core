import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/poll_states.dart';

class NewPollNotifer extends Notifier<PollStates>
    implements RtkPollsEventListener {
  @override
  void onNewPoll(Poll poll) {
    state = OnNewPoll(poll);
  }

  @override
  PollStates build() {
    return InitialPollState();
  }

  @override
  void onPollUpdates(List<Poll> polls) {}

  @override
  void onPollUpdate(Poll poll) {}
}

class PollListNotifier extends Notifier<List<Poll>>
    implements RtkPollsEventListener {
  @override
  List<Poll> build() {
    return rtkMeeting.polls.items;
  }

  @override
  void onPollUpdates(List<Poll> polls) {
    state = polls;
  }

  @override
  void onNewPoll(Poll poll) {}

  @override
  void onPollUpdate(Poll poll) {}
}

class UnreadPollNotifier extends Notifier<int>
    implements RtkPollsEventListener {
  int _read = 0;
  int _unread = 0;

  @override
  void onNewPoll(Poll poll) {}

  void markAllAsRead(int totalPolls) {
    _read = totalPolls;
    _unread = totalPolls;
    state = _unread - _read;
  }

  @override
  int build() {
    _read = 0;
    _unread = rtkMeeting.polls.items.length;
    return _unread - _read;
  }

  @override
  void onPollUpdates(List<Poll> polls) {
    _unread = polls.length - _read;
    state = _unread;
  }

  @override
  void onPollUpdate(Poll poll) {}
}
