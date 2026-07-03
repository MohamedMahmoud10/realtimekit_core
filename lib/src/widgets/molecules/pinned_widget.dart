import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/data/notifiers/pin_unpin_notifier.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:flutter/material.dart';

// TODO: convert it to not use Riverpod
class PinnedWidget extends StatefulWidget {
  const PinnedWidget(this.participant, {super.key});

  final RtkMeetingParticipant participant;

  @override
  State<PinnedWidget> createState() => _PinnedWidgetState();
}

class _PinnedWidgetState extends State<PinnedWidget> {
  late PinNotifier? _pinNotifier;

  @override
  void initState() {
    _pinNotifier = PinNotifier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _pinNotifier!,
        builder: (context, pinnedParticpant, child) {
          if (pinnedParticpant?.id == widget.participant.id) {
            return DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: backgroundColorSwatch.shade800,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(
                  DyteIcons.pin,
                  color: textColorSwatch.shade1000,
                  size: context.adjust(18),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
