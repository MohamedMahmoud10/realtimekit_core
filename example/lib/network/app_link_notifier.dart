import 'dart:async';

import 'package:example/models/either.dart';
import 'package:example/models/response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_link_service.dart';

class AppLinkNotifier extends Notifier<AppLinkState> {
  final AppLinkService _linkService = AppLinkService.instance;
  late StreamSubscription<Uri> _linkSubscription;

  Future<void> handleIncomingLinks() async {
    final initialLink = await _linkService.getInitialLink();
    switch (initialLink) {
      case Right():
        state = _getAppLinkStateFromUri(initialLink.value);
      case Left():
        break;
    }

    _linkSubscription = _linkService.getLinkStream().listen(
      (uri) => state = _getAppLinkStateFromUri(uri),
      onError:
          (_) =>
              state = RtkIdError('Oops! It seems, you tapped on a wrong link'),
    );
  }

  AppLinkState _getAppLinkStateFromUri(Uri uri) {
    // URL Pattern:https://demo.dyte.io/v2/meeting?id=<ID-we-want>&demo=Default
    RegExp regex = RegExp(r'(?<=id=)[a-fA-F0-9\-]+');
    Match? match = regex.firstMatch(uri.toString());
    if (match != null) {
      return RtkIdDetected(match.group(0)!);
    } else {
      return RtkIdError();
    }
  }

  void cancelLinkSubscription() => _linkSubscription.cancel();

  @override
  AppLinkState build() {
    return LinkInitial();
  }
}

final appLinkProvider = NotifierProvider<AppLinkNotifier, AppLinkState>(
  AppLinkNotifier.new,
);
