import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/di/di.dart';

class PollOptionSelectorNotifier extends Notifier<PollOption?> {
  final Poll pollMessage;
  PollOptionSelectorNotifier(this.pollMessage);

  PollOption? get selectedOption => state;

  @override
  build() {
    for (final option in pollMessage.options) {
      if (option.votes
          .any((element) => element.id == rtkMeeting.localUser.userId)) {
        return option;
      }
    }
    return null;
  }
}
