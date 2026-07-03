import 'package:example/models/response.dart';
import 'package:example/network/app_link_notifier.dart';
import 'package:example/network/rtk_meeting_notifier.dart';
import 'package:example/network/rtk_theme_notifier.dart';
import 'package:example/utils/snackbar.dart';
import 'package:example/pages/meeting_page.dart';
import 'package:example/widgets/theme_selector.dart';
import 'package:example/widgets/create_meeting_widget.dart';
import 'package:example/widgets/join_meeting_widget.dart';
import 'package:example/widgets/auth_token_widget.dart';
import 'package:example/widgets/cloud_backend_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';

class MeetingJoinAndCreatePage extends ConsumerStatefulWidget {
  const MeetingJoinAndCreatePage({super.key});

  @override
  ConsumerState<MeetingJoinAndCreatePage> createState() =>
      _MeetingJoinAndCreatePageState();
}

class _MeetingJoinAndCreatePageState
    extends ConsumerState<MeetingJoinAndCreatePage> {
  final TextEditingController _meetingTitleController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _meetingCodeController = TextEditingController();
  final TextEditingController _nameController2 = TextEditingController();
  final TextEditingController _authTokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(appLinkProvider.notifier).handleIncomingLinks();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rtkMeetingNotifier = ref.watch(rtkMeetingProvider.notifier);

    ref.listen(rtkMeetingProvider, (prev, next) {
      switch (next) {
        case Success():
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                final RealtimeKitUIInfo uiKitInfo = RealtimeKitUIInfo(
                  next.value,
                  designToken: RtkDesignTokens(
                    colorToken: ref.read(rtkThemeProvider).colorToken,
                  ),
                  // Demo of the new API: any widget (here the app logo) is
                  // rendered at the leading edge of the in-meeting app bar.
                  customAppBarWidget: Image.asset(
                    'assets/logo.png',
                    height: 28,
                  ),
                );
                return RtkMeetingPage(uiKitInfo);
              },
            ),
          );
          break;
        case _:
          break;
      }
    });

    ref.listen(appLinkProvider, (prev, next) {
      switch (next) {
        case LinkInitial():
          break;
        case RtkIdDetected():
          setState(() {
            _meetingCodeController.text = next.meetingId;
          });
          break;
        case RtkIdError():
          showSnackbar(context, next.msg);
          break;
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logo.png', height: 32),
            const SizedBox(width: 8),
            Text('Rtk Flutter Sample App', style: theme.textTheme.titleMedium),
          ],
        ),
      ),
      body:
          ref.watch(rtkMeetingProvider).runtimeType == Loading
              ? const Center(child: CircularProgressIndicator())
              : _buildInitialWidget(theme, context, rtkMeetingNotifier),
    );
  }

  Widget _buildInitialWidget(
    ThemeData theme,
    BuildContext context,
    RtkMeetingNotifier rtkMeetingNotifier,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CloudBackendSwitch(),
              const SizedBox(height: 24),
              Text("Join with Auth Token", style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              AuthTokenWidget(authTokenController: _authTokenController),
              const Divider(height: 40),
              JoinMeetingWidget(
                meetingCodeController: _meetingCodeController,
                nameController: _nameController2,
              ),
              const Divider(height: 40),
              CreateMeetingWidget(
                meetingTitleController: _meetingTitleController,
                nameController: _nameController,
              ),
              const Divider(height: 40),
              Text("Choose theme", style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              const ThemeSelectorWidget(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    ref.read(appLinkProvider.notifier).cancelLinkSubscription();
    super.dispose();
  }
}

// Theme selection and input widgets moved to example/widgets/* and sections to example/pages/sections/*
