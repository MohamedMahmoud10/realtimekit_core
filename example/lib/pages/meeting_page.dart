import 'package:flutter/material.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';

class RtkMeetingPage extends StatefulWidget {
  const RtkMeetingPage(this.uiKitInfo, {super.key});
  final RealtimeKitUIInfo uiKitInfo;

  @override
  State<RtkMeetingPage> createState() => _RtkMeetingPageState();
}

class _RtkMeetingPageState extends State<RtkMeetingPage> {
  @override
  Widget build(BuildContext context) {
    final uiKit = RealtimeKitUIBuilder.build(uiKitInfo: widget.uiKitInfo);
    return uiKit;
  }

  @override
  void dispose() {
    RealtimeKitUIBuilder.dispose();
    super.dispose();
  }
}
