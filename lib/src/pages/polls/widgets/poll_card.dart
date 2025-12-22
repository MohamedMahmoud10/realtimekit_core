import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/data/states/poll_states.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text_button.dart';

import '../../../data/notifiers/poll_option_selector_notifier.dart';

class PollCard extends ConsumerStatefulWidget {
  final Poll pollMessage;
  const PollCard({
    super.key,
    required this.pollMessage,
  });

  @override
  ConsumerState<PollCard> createState() => _PollCardState();
}

class _PollCardState extends ConsumerState<PollCard> {
  late final pollOptionSelectorNotifier =
      NotifierProvider<PollOptionSelectorNotifier, PollOption?>(() {
    return PollOptionSelectorNotifier(widget.pollMessage);
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    // final pollPermissions = rtkClient.permissions.pollPermissions;

    PollOption? votedOption;
    final currentUserId = rtkMeeting.localUser.userId;
    try {
      votedOption = widget.pollMessage.options.firstWhere((opt) {
        return opt.votes.any((voter) => voter.id == currentUserId);
      });
    } catch (e) {
      votedOption = null;
    }
    return Column(
      children: [
        RtkText(
          "${RtkStrings.pollBy} ${widget.pollMessage.createdBy}",
          rtkTextStyle: theme.textTheme.titleMedium!
              .copyWith(color: theme.colorScheme.onSecondary),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: Card(
            color: theme.colorScheme.primaryContainer,
            margin: EdgeInsets.symmetric(
              horizontal: context.adjust(8),
              vertical: context.adjust(2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.adjust(18),
                    vertical: context.adjust(8),
                  ),
                  child: RtkText(
                    widget.pollMessage.question,
                    disableOverflow: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: OptionSelector(
                    poll: widget.pollMessage,
                    optionSelectorNotifier: pollOptionSelectorNotifier,
                    votedOption: votedOption,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.adjust(18),
                    ),
                    child: Divider(
                      color: theme.colorScheme.tertiaryContainer,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OptionSelector extends ConsumerStatefulWidget {
  final Poll poll;
  final NotifierProvider<PollOptionSelectorNotifier, PollOption?>
      optionSelectorNotifier;
  final PollOption? votedOption;
  const OptionSelector({
    super.key,
    required this.poll,
    required this.optionSelectorNotifier,
    required this.votedOption,
  });

  @override
  ConsumerState<OptionSelector> createState() => OptionSelectorState();
}

class OptionSelectorState extends ConsumerState<OptionSelector> {
  int _calculateAllVotes(Poll poll) {
    return poll.options.fold(0, (totalVotes, opt) => totalVotes + opt.count);
  }

  Future<void> showVotersList(PollOption option) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: option.votes.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: RtkText(option.votes[index].name),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;

    ref.listen(pollsListNotifier, (previous, next) {
      if (next is OnPollUpdates) {
        final thisPoll = next.firstWhere((poll) => poll.id == widget.poll.id);
        if (thisPoll != widget.poll) {
          setState(() {});
        }
      }
    });

    return Column(children: [
      ...widget.poll.options.map((opt) {
        return Row(
          children: [
            Radio(
              value: opt,
              groupValue: widget.votedOption ??
                  ref.watch(widget.optionSelectorNotifier),
              activeColor: theme.colorScheme.primary,
              fillColor: WidgetStateProperty.all(theme.colorScheme.primary),
              onChanged: widget.votedOption == null
                  ? (_) {
                      rtkMeeting.polls.vote(
                        poll: widget.poll,
                        pollOption: opt,
                      );
                    }
                  : null,
            ),
            Expanded(
              child: RtkText(
                opt.text,
                disableOverflow: true,
              ),
            ),
            // If hideVotes is false, then show the result as the poll is ongoing
            // or if hideVotes is true, then show the result only when all the participants have voted

            if (( // condition 1: if this client is the creator of the poll -> show `View Votes` button on the go
                    widget.poll.createdBy == rtkMeeting.localUser.name ||
                        // if anonymous is false and
                        (widget.poll.anonymous == false &&
                            // condition 2: if hideVotes is false -> show `View Votes` button on the go
                            (widget.poll.hideVotes == false ||
                                // condition 3: if hide votes is true, and all the participants have voted -> show `View Votes` button
                                (widget.poll.hideVotes &&
                                    _calculateAllVotes(widget.poll) ==
                                        rtkMeeting
                                            .participants.joined.length)))) &&
                // condition 4: if the option has votes -> show `View Votes` button
                opt.count > 0)
              RtkTextButton(
                onPressed: () => showVotersList(opt),
                borderColor: theme.colorScheme.primary,
                variant: Variant.secondary,
                label: RtkStrings.viewVoters,
                labelStyle: theme.textTheme.bodySmall,
              ),

            if (widget.poll.createdBy == rtkMeeting.localUser.name ||
                widget.poll.hideVotes == false ||
                (widget.poll.hideVotes &&
                    _calculateAllVotes(widget.poll) ==
                        rtkMeeting.participants.joined.length))
              RtkText(
                " (${opt.votes.length.toString()})",
              ),
          ],
        );
      })
    ]);
  }
}
