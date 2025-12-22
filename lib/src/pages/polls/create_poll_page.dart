import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/routes/router.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_app_bar.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text_button.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text_field.dart';

import 'package:realtimekit_ui/src/widgets/core/core.dart';
import 'package:realtimekit_ui/src/widgets/molecules/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/atoms/rtk_icon_button.dart';

class CreatePollPage extends ConsumerStatefulWidget {
  const CreatePollPage({super.key});

  @override
  ConsumerState<CreatePollPage> createState() => _CreatePollPageState();
}

class _CreatePollPageState extends ConsumerState<CreatePollPage> {
  final TextEditingController questionController = TextEditingController();

  // Maintaining a list of mandatory option controllers.
  final List<TextEditingController> mandatoryOptionsController = [
    TextEditingController(),
    TextEditingController(),
  ];

  List<TextEditingController> moreOptionsController = [];

  bool anonymous = false;
  bool hideVotes = true;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return Scaffold(
      appBar: RtkAppBar(
        title: RtkText(RtkStrings.createPoll),
        hasLeading: false,
        actions: [
          IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(DyteIcons.dismiss))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.adjust(8)),
          child: SingleChildScrollView(
            child: SizedBox(
              width: context.width * 0.98,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: context.adjust(10),
                  ),
                  RtkText(RtkStrings.question),
                  SizedBox(
                    height: context.adjust(5),
                  ),
                  SizedBox(
                    width: context.width,
                    child: RtkTextField(
                      controller: questionController,
                      hintText: RtkStrings.askAQuestion,
                      hintStyle: theme.textTheme.titleMedium,
                    ),
                  ),
                  RtkText(RtkStrings.options),
                  SizedBox(
                    height: context.adjust(5),
                  ),
                  ...mandatoryOptionsController.map(
                    (optController) => SizedBox(
                      width: context.width,
                      child: RtkTextField(
                        controller: optController,
                        hintText: RtkStrings.enterAnOption,
                        hintStyle: theme.textTheme.titleMedium,
                      ),
                    ),
                  ),
                  ...moreOptionsController.map(
                    (addOptController) => Row(
                      children: [
                        Expanded(
                          child: RtkTextField(
                            controller: addOptController,
                            hintText: RtkStrings.enterAnOption,
                            hintStyle: theme.textTheme.titleMedium,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: context.adjust(15)),
                          child: RtkIconButton(
                            icon: const Icon(DyteIcons.subtract),
                            onPressed: () {
                              setState(() {
                                moreOptionsController.removeWhere(
                                  (element) => element == addOptController,
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: RtkButtons.solid(
                      onPressed: () {
                        setState(() {
                          moreOptionsController.add(TextEditingController());
                        });
                      },
                      width: context.width,
                      label: RtkStrings.addOption,
                    ),
                  ),
                  Row(
                    children: [
                      Switch.adaptive(
                        onChanged: (value) => setState(() {
                          anonymous = value;
                          if (anonymous == true) {
                            hideVotes = true;
                          }
                        }),
                        value: anonymous,
                      ),
                      RtkText(RtkStrings.anonymous),
                    ],
                  ),
                  Row(
                    children: [
                      Switch.adaptive(
                        onChanged: (value) => anonymous
                            ? null
                            : setState(() {
                                hideVotes = value;
                              }),
                        value: hideVotes,
                      ),
                      RtkText(RtkStrings.hideResultsBeforeVoting),
                    ],
                  ),
                  Center(
                    child: RtkTextButton(
                      width: context.width * 0.5,
                      onPressed: () {
                        final options = [
                          ...mandatoryOptionsController
                              .map((mandatoryOpt) => mandatoryOpt.text.trim())
                              .toList(),
                          ...moreOptionsController
                              .map((moreOpt) => moreOpt.text.trim())
                              .toList(),
                        ];
                        if (questionController.text.trim().isEmpty ||
                            options.any((opt) => opt.isEmpty)) {
                          showSnackbarWidget(
                            context,
                            getTextContentForSnackbar(
                              RtkStrings.questionAndOptionsCantBeEmpty,
                              context,
                            ),
                          );
                        }
                        rtkMeeting.polls.create(
                          question: questionController.text.trim(),
                          options: options,
                          anonymous: anonymous,
                          hideVotes: hideVotes,
                        );
                        RtkRouter.of(context).pop();
                      },
                      label: RtkStrings.createPoll,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
