import 'package:flutter/material.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';

class RtkMeetingPage extends StatefulWidget {
  const RtkMeetingPage(this.uiKitInfo, {super.key});
  final RealtimeKitUIInfo uiKitInfo;

  @override
  State<RtkMeetingPage> createState() => _RtkMeetingPageState();
}

class _RtkMeetingPageState extends State<RtkMeetingPage> {
  // We own the client instance so we can release the native meeting when this
  // page is disposed, regardless of the SDK's internal GetIt teardown.
  final RealtimekitClient _client = RealtimekitClient();

  @override
  Widget build(BuildContext context) {
    final uiKit = RealtimeKitUIBuilder.build(
      uiKitInfo: widget.uiKitInfo,
      meeting: _client,
    );
    return uiKit;
  }

  @override
  void dispose() {
    // The native RealtimeKit client is a single long-lived instance that is
    // only rebuilt on app/activity restart. Without release() it stays in a
    // joined-then-left state and the next init() emits no events, leaving a
    // re-joined meeting stuck on the loading screen. Releasing here frees the
    // native meeting so the next init() starts clean.
    _client.release();
    RealtimeKitUIBuilder.dispose();
    super.dispose();
  }
}
