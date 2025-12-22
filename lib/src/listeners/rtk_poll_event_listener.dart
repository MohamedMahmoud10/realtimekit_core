import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';

abstract class RtkPollsEventListener extends RtkListener {
  void onPollUpdates(List<Poll> pollItems) {}
  void onNewPoll(Poll poll) {}
  void onPollUpdate(Poll poll) {}
}

class RtkPollController extends RtkPollsEventListener {
  RtkPollController._();
  static final RtkPollController instance = RtkPollController._();
  final List<Poll> _polls = [];

  List<Poll> get items => _polls;

  @override
  void onPollUpdates(List<Poll> pollItems) {
    _polls.clear();
    _polls.addAll(pollItems);
  }

  void dispose() {
    _polls.clear();
  }
}
