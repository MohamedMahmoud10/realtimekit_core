import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/data/notifiers/participants_notifier.dart';
import 'package:realtimekit_ui/src/tokens/font/font_size.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class RtkDependencyHandler {
  static late RealtimeKitUIInfo uikitInfo;
  static late RealtimekitClient? client;
  static void setupDependecies(
    RealtimeKitUIInfo rtkUIKitInfo,
    RealtimekitClient? client,
  ) {
    RtkDependencyHandler.uikitInfo = rtkUIKitInfo;
    RtkDependencyHandler.client = client;
    getIt.registerFactory<RtkDesignTokens>(() => rtkUIKitInfo.designToken);
    getIt.registerSingleton<FontSize>(FontSize());
    getIt.registerSingleton<RealtimekitClient>(client ?? RealtimekitClient());
    getIt.registerSingleton<RtkMeetingInfo>(rtkUIKitInfo.meetingInfo);
    getIt.registerLazySingleton<RtkConfig>(() => RtkConfig());
    getIt.registerLazySingleton<ParticipantsNotifier>(
        () => ParticipantsNotifier());
  }

  static void tearDownDependencies() {
    if (getIt.isRegistered<RtkDesignTokens>()) {
      getIt.unregister<RtkDesignTokens>();
    }

    if (getIt.isRegistered<FontSize>()) {
      getIt.unregister<FontSize>();
    }

    if (getIt.isRegistered<RealtimekitClient>()) {
      getIt.unregister<RealtimekitClient>();
    }

    if (getIt.isRegistered<RtkMeetingInfo>()) {
      getIt.unregister<RtkMeetingInfo>();
    }
    if (getIt.isRegistered<RtkConfig>()) {
      getIt.unregister<RtkConfig>();
    }
    if (getIt.isRegistered<ParticipantsNotifier>()) {
      getIt.unregister<ParticipantsNotifier>();
    }
  }
}

RtkDesignTokens get globalDesignToken => getIt.get<RtkDesignTokens>();
BorderToken get borderToken => globalDesignToken.borderToken;

LinearColorSwatch get textColorSwatch => globalDesignToken.colorToken.textColor;
RangedColorSwatch get brandColorSwatch =>
    globalDesignToken.colorToken.brandColor;
LinearColorSwatch get backgroundColorSwatch =>
    globalDesignToken.colorToken.backgroundColor;
FontSize get fontSize => getIt.get<FontSize>();

RealtimekitClient get rtkMeeting => getIt.get<RealtimekitClient>();

RtkMeetingInfo get meetingInfo => getIt.get<RtkMeetingInfo>();

RtkConfig get rtkConfig => getIt.get<RtkConfig>();

ParticipantsNotifier get participantNotifier =>
    getIt.get<ParticipantsNotifier>();
