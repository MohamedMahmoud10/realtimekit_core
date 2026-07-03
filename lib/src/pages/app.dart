import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/data/manage_listeners.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/pages/room_route_page.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class RtkApp extends ConsumerStatefulWidget {
  final RtkMeetingInfo rtkMeetingInfo;
  const RtkApp(this.rtkMeetingInfo, {super.key});
  @override
  ConsumerState<RtkApp> createState() => _RtkAppState();
}

class _RtkAppState extends ConsumerState<RtkApp> {
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    RtkListenerManager.init(ref);
    if (mounted) {
      RtkListenerManager.instance.registerRtkListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme(globalDesignToken.colorToken);
    return MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [
        Locale(RtkStrings.locale),
      ],
      theme: appTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const RoomRoutePage(),
    );
  }

  @override
  void dispose() {
    RealtimeKitUIBuilder.dispose();
    super.dispose();
  }
}

class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
