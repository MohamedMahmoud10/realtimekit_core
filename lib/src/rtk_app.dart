import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/data/provider_logger.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/pages/app.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:realtimekit_ui/src/tokens/size/size_config.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RealtimeKitUIInfo {
  final RtkMeetingInfo meetingInfo;
  final RtkDesignTokens _designToken;

  /// Optional widget rendered at the leading (left) edge of the in-meeting
  /// app bar for every meeting type (group call, webinar, livestream) — most
  /// commonly a brand logo. The meeting title, participant count, timer and
  /// action buttons are preserved. When null the app bar is unchanged.
  final Widget? customAppBarWidget;

  RtkDesignTokens get designToken => _designToken;

  RealtimeKitUIInfo(
    this.meetingInfo, {
    RtkDesignTokens? designToken,
    this.customAppBarWidget,
  }) : _designToken = designToken ?? RtkDesignTokens();
}

class RtkConfig {
  bool skipSetupScreen = false;

  /// Consumer-supplied widget shown at the leading edge of the in-meeting app
  /// bar (see [RealtimeKitUIInfo.customAppBarWidget]). Null means no change.
  Widget? customAppBarWidget;
}

class RealtimeKitUIBuilder {
  final RealtimeKitUIInfo uiKitInfo;

  RealtimeKitUIBuilder._(this.uiKitInfo, this.arbPath);
  final String? arbPath;

  static RealtimeKitUI build({
    required RealtimeKitUIInfo uiKitInfo,
    String? arbPath,
    RealtimekitClient? meeting,
    bool skipSetupPage = false,
  }) {
    if (arbPath != null) {
      RtkStrings(arbPath: arbPath).init();
    }
    if (!getIt.isRegistered<RtkDesignTokens>()) {
      RtkDependencyHandler.setupDependecies(uiKitInfo, meeting);
    }
    return RealtimeKitUI(
      uiKitInfo,
      skipSetupPage: skipSetupPage,
    );
  }

  static void dispose() {
    RtkDependencyHandler.tearDownDependencies();
  }
}

class RealtimeKitUI extends StatelessWidget {
  final RealtimeKitUIInfo _uiKitInfo;
  final bool skipSetupPage;
  const RealtimeKitUI(
    this._uiKitInfo, {
    this.skipSetupPage = false,
    super.key,
  });
  RealtimeKitUIInfo get uikitInfo => _uiKitInfo;
  RealtimekitClient get meeting => rtkMeeting;

  Widget _app() {
    rtkConfig.skipSetupScreen = skipSetupPage;
    rtkConfig.customAppBarWidget = uikitInfo.customAppBarWidget;
    return RtkApp(uikitInfo.meetingInfo);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RtkProvider(
      observers: [Logger()],
      meeting: rtkMeeting,
      uiKitInfo: uikitInfo,
      child: WillPopScope(
        onWillPop: () async => false,
        child: _app(),
      ),
    );
  }
}

class RtkProvider extends StatefulWidget {
  const RtkProvider({
    Key? key,
    required this.child,
    required this.meeting,
    required this.uiKitInfo,
    this.observers,
  }) : super(key: key);

  final List<ProviderObserver>? observers;
  final Widget child;
  final RealtimekitClient meeting;
  final RealtimeKitUIInfo uiKitInfo;

  @override
  State<RtkProvider> createState() => _RtkProviderState();
}

class _RtkProviderState extends State<RtkProvider> {
  @override
  void initState() {
    if (!getIt.isRegistered<RtkDesignTokens>()) {
      RtkDependencyHandler.setupDependecies(
        widget.uiKitInfo,
        widget.meeting,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme(globalDesignToken.colorToken);
    return OrientationBuilder(
      builder: (context, orientation) {
        SizeConfig().init(context);
        return ProviderScope(
          observers: widget.observers,
          child: Theme(
            data: appTheme.theme,
            child: widget.child,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    RtkDependencyHandler.tearDownDependencies();
    super.dispose();
  }
}
