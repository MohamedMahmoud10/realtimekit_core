import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_icon_button.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';
import 'package:realtimekit_ui/src/widgets/atoms/vh_space.dart';
import 'package:flutter/material.dart';

class RtkFileMessageLayout extends StatelessWidget {
  final FileMessage fileMessage;
  const RtkFileMessageLayout({
    super.key,
    required this.fileMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RtkText(
                fileMessage.displayName,
                rtkTextStyle: theme.textTheme.displaySmall,
              ),
              const SizedBox(width: 8),
            ],
          ),
          vspace1,
          Row(
            children: [
              SizedBox(
                width: context.width * 0.5,
                child: RtkText(
                  fileMessage.name,
                ),
              ),
              const Spacer(),
              RtkIconButton(
                  icon: Icon(
                    DyteIcons.download,
                    color: theme.colorScheme.onSecondary,
                  ),
                  onPressed: () {
                    rtkMeeting.chat.downloadAttachment(
                      fileMessage.link,
                      fileName: fileMessage.name,
                    );
                  }),
            ],
          )
        ],
      ),
    );
  }
}
