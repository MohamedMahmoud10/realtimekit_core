import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';

abstract class RtkPolls {
  List<Poll> get items => RtkPollController.instance.items;
  void create({
    required String question,
    required List<String> options,
    required bool anonymous,
    required bool hideVotes,
  });

  void vote({
    required Poll poll,
    required PollOption pollOption,
  });
}
