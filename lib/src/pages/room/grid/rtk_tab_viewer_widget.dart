import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/data/notifiers/pin_unpin_notifier.dart';
import 'package:realtimekit_ui/src/pages/room/grid/rtk_tab_list_widget.dart';
import 'package:realtimekit_ui/src/pages/room/grid/selected_tab_viewer_widget.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RtkTabViewerWidget extends StatelessWidget {
  const RtkTabViewerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget tabViewer = SingleChildScrollView(
      child: Column(
        children: [
          const TabListWidget(),
          Stack(children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: context.width,
                maxHeight: context.height * 0.70,
              ),
              child: const SelectedTabViewerWidget(),
            ),
            const Positioned(
              bottom: 4,
              right: 4,
              child: _PinnedFloatingWidget(),
            ),
          ]),
        ],
      ),
    );
    return tabViewer;
  }
}

class _PinnedFloatingWidget extends StatefulWidget {
  const _PinnedFloatingWidget();

  @override
  State<_PinnedFloatingWidget> createState() => _PinnedFloatingWidgetState();
}

class _PinnedFloatingWidgetState extends State<_PinnedFloatingWidget> {
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
      builder: (context, pinnedParticipant, child) {
        return pinnedParticipant != null
            ? ConstrainedBox(
                key: ValueKey(pinnedParticipant.id),
                constraints: BoxConstraints(
                  maxWidth: context.adjust(140),
                  maxHeight: context.adjust(180),
                ),
                child: RtkParticipantTile(
                  pinnedParticipant,
                ))
            : const SizedBox.shrink();
      },
    );
  }

  @override
  void dispose() {
    if (_pinNotifier != null) {
      _pinNotifier = null;
    }

    super.dispose();
  }
}
