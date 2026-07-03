import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/pages/polls/widgets/poll_card.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllPolls extends ConsumerStatefulWidget {
  const AllPolls({super.key});

  @override
  ConsumerState<AllPolls> createState() => _AllPollsState();
}

class _AllPollsState extends ConsumerState<AllPolls> {
  List<Poll> _allPolls = [];
  @override
  void initState() {
    super.initState();
    _allPolls = rtkMeeting.polls.items;
  }

  @override
  Widget build(BuildContext context) {
    // const pollPermissions = true;
// TODO : Add permission check
    return SizedBox(
        height: context.height * .9,
        child: ListView.separated(
          separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: context.adjust(8)),
              child: const Divider()),
          itemBuilder: (context, index) => PollCard(
            pollMessage: _allPolls[index],
          ),
          itemCount: _allPolls.length,
        ));
  }
}
