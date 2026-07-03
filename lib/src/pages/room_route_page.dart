import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/data/states/router_states.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:realtimekit_ui/src/pages/exception_page.dart';
import 'package:realtimekit_ui/src/pages/room/meetingRooms/gc_meeting_room.dart';
import 'package:realtimekit_ui/src/pages/room/meetingRooms/livestream_meeting_room.dart';
import 'package:realtimekit_ui/src/pages/room/meetingRooms/webinar_meeting_room.dart';
import 'package:realtimekit_ui/src/pages/waiting_room_page.dart';
import 'package:realtimekit_ui/src/routes/route_names.dart';
import 'package:realtimekit_ui/src/widgets/atoms/vh_space.dart';
import 'package:realtimekit_ui/src/widgets/utils/clean_pop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

class RoomRoutePage extends ConsumerStatefulWidget {
  const RoomRoutePage({super.key});

  @override
  ConsumerState<RoomRoutePage> createState() => _RoomRoutePageState();
}

class _RoomRoutePageState extends ConsumerState<RoomRoutePage> {
  AudioDevice? selectedAudioDevice;
  VideoDevice? selectedVideoDevice;
  bool _isReconnectionDialogShown = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(routerNotifier, (previous, next) async {
      switch (next.runtimeType) {
        case OnRouterMeetingInitStarted:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoadingScreen(),
            ),
          );
          break;
        case OnRouterMeetingInitCompleted:
          rootBundle
              .loadString(
            "packages/realtimekit_ui/pubspec.yaml",
          )
              .then((value) {
            final pubspec = Pubspec.parse(value);

            rtkMeeting.setSdkInfo(
                pubspec.name, pubspec.version?.canonicalizedVersion ?? '');
          });
          rtkMeeting.localUser
              .getSelectedAudioDevice()
              .then((audioDevice) {
                selectedAudioDevice = audioDevice;
                if ((audioDevice == null ||
                        !rtkMeeting.localUser.isMicrophonePermissionGranted) &&
                    rtkMeeting.localUser.audioEnabled) {
                  rtkMeeting.localUser.disableAudio();
                }
              })
              .then((_) => rtkMeeting.localUser
                      .getSelectedVideoDevice()
                      .then((videoDevice) {
                    selectedVideoDevice = videoDevice;
                    if ((videoDevice == null ||
                            !rtkMeeting.localUser.isCameraPermissionGranted) &&
                        rtkMeeting.localUser.videoEnabled) {
                      rtkMeeting.localUser.disableVideo();
                    }
                  }))
              .then(
                (_) async {
                  if (rtkConfig.skipSetupScreen) {
                    rtkMeeting.joinRoom();
                  } else {
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RtkSetupScreen(
                            selectedAudioDevice, selectedVideoDevice),
                        settings: RouteSettings(name: RouteNames.setup),
                      ),
                    );
                  }
                },
              );
          break;
        case OnRouterMeetingInitFailed:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ExceptionPage((next as OnRouterMeetingInitFailed).error),
              settings: RouteSettings(name: RouteNames.exception),
            ),
          );
          break;
        case OnRouterMeetingRoomJoinStarted:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoadingScreen(),
            ),
          );
          break;
        case OnRouterMeetingRoomJoinCompleted:
          switch (rtkMeeting.meta.meetingType) {
            case RtkMeetingType.groupCall:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const RtkGCMeetingRoom(),
                  settings: RouteSettings(name: RouteNames.meeting),
                ),
              );
              break;
            case RtkMeetingType.webinar:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RtkWebinarMeetingRoom(
                      selectedAudioDevice, selectedVideoDevice),
                  settings: RouteSettings(name: RouteNames.meeting),
                ),
              );
              break;
            case RtkMeetingType.livestream:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RtkLivestreamMeetingRoom(
                      selectedAudioDevice, selectedVideoDevice),
                  settings: RouteSettings(name: RouteNames.meeting),
                ),
              );
              break;
          }
          break;

        case OnRouterMeetingRoomJoinFailed:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExceptionPage(
                (next as OnRouterMeetingRoomJoinFailed).error,
              ),
              settings: RouteSettings(name: RouteNames.exception),
            ),
          );
          break;
        case OnRouterMeetingRoomLeaveCompleted:
          await RtkUtils(context).leave(ref);
          break;

        case OnRouterSelfWaitingRoomStatusUpdate:
          switch (
              (next as OnRouterSelfWaitingRoomStatusUpdate).waitListStatus) {
            case WaitlistStatus.waiting:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const WaitingRoomPage(),
                  settings: RouteSettings(name: RouteNames.waitingRoom),
                ),
              );
              break;
            case WaitlistStatus.rejected:
              RtkUtils(context).leave(ref, release: true);
              break;
            default:
              break;
          }
          break;
        case OnRouterMeetingRoomDisconnected:
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.transparent,
            builder: (ctx) => const ReconnectionNotificationWidget(),
          );
          break;

        case OnRouterMeetingRoomReconnecting:
          if (!context.mounted || _isReconnectionDialogShown) break;
          _isReconnectionDialogShown = true;
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.transparent,
            useRootNavigator: true,
            builder: (ctx) => const ReconnectionNotificationWidget(),
          );
          break;

        case OnRouterMeetingRoomReconnected:
          if (context.mounted) {
            if (_isReconnectionDialogShown) {
              Navigator.of(context, rootNavigator: true).pop();
              _isReconnectionDialogShown = false;
            }

            final currentRoute = ModalRoute.of(context)?.settings.name;
            if (currentRoute != RouteNames.meeting) {
              Widget meetingRoom;
              switch (rtkMeeting.meta.meetingType) {
                case RtkMeetingType.groupCall:
                  meetingRoom = const RtkGCMeetingRoom();
                  break;
                case RtkMeetingType.webinar:
                  meetingRoom = RtkWebinarMeetingRoom(
                      selectedAudioDevice, selectedVideoDevice);
                  break;
                case RtkMeetingType.livestream:
                  meetingRoom = RtkLivestreamMeetingRoom(
                      selectedAudioDevice, selectedVideoDevice);
                  break;
              }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => meetingRoom,
                  settings: RouteSettings(name: RouteNames.meeting),
                ),
              );
            }
          }
          break;

        case OnRouterMeetingRoomReconnectionFailed:
          if (context.mounted) {
            Navigator.of(context, rootNavigator: true).pop();
            // Show error to user
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Connection Failed'),
                content: const Text(
                    'Unable to reconnect to the meeting. Please try again later.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
          break;

        case OnRouterMeetingEnded:
          await RtkUtils(context).leave(ref, release: true);
          break;

        case OnRouterRemovedFromMeeting:
          await RtkUtils(context).leave(ref, release: true);
          break;
      }
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      rtkMeeting.init(meetingInfo);
    }
  }
}

class ReconnectionNotificationWidget extends ConsumerWidget {
  const ReconnectionNotificationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      backgroundColor: colorScheme.surfaceContainerHighest.withOpacity(0.95),
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.primary,
                    ),
                    strokeWidth: 2.5,
                  ),
                ),
                hspace4,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reconnecting...',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Trying to restore your connection',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
