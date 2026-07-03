import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';
import 'package:realtimekit_ui/src/widgets/atoms/vh_space.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RtkTextMessageWidget extends StatelessWidget {
  // final DyteChatMessage message;
  final TextMessage textMessage;
  const RtkTextMessageWidget({
    super.key,
    required this.textMessage,
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
                textMessage.displayName,
                rtkTextStyle: theme.textTheme.displaySmall,
              ),
              const SizedBox(width: 8),
              RtkText(
                textMessage.time,
                rtkTextStyle: theme.textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
          vspace1,
          Text.rich(
            _styleUrlsInText(textMessage.message),
            style: theme.textTheme.bodyMedium,
          )
        ],
      ),
    );
  }

  TextSpan _styleUrlsInText(String text) {
    // TODO: we can alter this acc to web version of dyte.
    final urlRegex = RegExp(r'\b(?:https?://|www\.)\S+\b');

    List<InlineSpan> spans = [];

    int currentIndex = 0;
    for (final match in urlRegex.allMatches(text)) {
      // Add the text before the match
      final beforeMatch = text.substring(currentIndex, match.start);
      if (beforeMatch.isNotEmpty) {
        spans.add(TextSpan(text: beforeMatch));
      }

      // Add the matched URL with an underline style and GestureDetector
      String? url = match.group(0);
      spans.add(TextSpan(
        text: url,
        style: const TextStyle(decoration: TextDecoration.underline),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            rtkMeeting.launchUrl(url!);
          },
      ));

      currentIndex = match.end;
    }

    // Add any remaining text after the last match
    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }

    return TextSpan(children: spans);
  }
}
