import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/pages/polls/create_poll_page.dart';
import 'package:realtimekit_ui/src/routes/router.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_app_bar.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';
import 'package:flutter/material.dart';

import '../../widgets/atoms/rtk_button.dart';
import 'widgets/polls_viewer_widget.dart';

class RtkPollsScreen extends StatelessWidget {
  const RtkPollsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return Scaffold(
      appBar: RtkAppBar(
        title: RtkText(RtkStrings.polls),
        hasLeading: false,
        actions: [
          IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(DyteIcons.dismiss))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: context.adjust(5),
            ),
            if (rtkMeeting.permissions.poll.canView)
              const Expanded(
                child: PollsViewerWidget(),
              ),
            if (rtkMeeting.permissions.poll.canCreate)
              RtkButton(
                height: context.adjust(48),
                onPressed: () {
                  RtkRouter.of(context).push(
                    const CreatePollPage(),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      DyteIcons.add,
                      color: theme.colorScheme.onSecondary,
                    ),
                    RtkText(
                      RtkStrings.createPoll,
                      rtkTextStyle: theme.textTheme.displayMedium,
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
