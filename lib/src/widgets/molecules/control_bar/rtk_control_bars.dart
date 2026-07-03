import 'package:realtimekit_ui/src/data/notifiers/audio_notifier.dart';
import 'package:realtimekit_ui/src/data/notifiers/video_notifier.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/widgets/molecules/more_button_widget.dart';
import 'package:realtimekit_ui/src/widgets/molecules/screenshare_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../realtimekit_ui.dart';
import '../../../di/riverpod_di.dart';
import '../../../tokens/size/size_util.dart';
import '../stage_req_button_widget.dart';

class RtkControlBar {
  RtkControlBar._();

  static Widget gc({RtkDesignTokens? designToken}) => SafeArea(
        child: _RtkGCControlBar(
          individualDesignToken: designToken,
        ),
      );
  static Widget webinar({RtkDesignTokens? designToken}) => SafeArea(
        child: _RtkStageControlBar(
          individualDesignToken: designToken,
        ),
      );
  static Widget livestream({RtkDesignTokens? designToken}) => SafeArea(
        child: _RtkStageControlBar(
          individualDesignToken: designToken,
          canLivestream: rtkMeeting.permissions.livestream.canLivestream,
        ),
      );
}

class _RtkGCControlBar extends ConsumerStatefulWidget {
  final RtkDesignTokens? individualDesignToken;
  const _RtkGCControlBar({this.individualDesignToken});

  @override
  ConsumerState<_RtkGCControlBar> createState() => _RtkGCControlBarState();
}

class _RtkGCControlBarState extends ConsumerState<_RtkGCControlBar> {
  late RtkDataEventListener stagePerms;
  late AudioNotifier _audioNotifier;
  late VideoNotifier _videoNotifier;
  @override
  void initState() {
    _audioNotifier = AudioNotifier(rtkMeeting.localUser);
    _videoNotifier = VideoNotifier(rtkMeeting.localUser);
    stagePerms = ref.read(stagePermissionNotifier.notifier);
    rtkMeeting.addDataUpdateEventListener(stagePerms);
    rtkMeeting.addParticipantsEventListener(_audioNotifier);
    rtkMeeting.addParticipantsEventListener(_videoNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final iconWidth = (context.width - 8) / 8;
    return Container(
      height: context.adjust(bottomNavbarHeight + 6),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      decoration: BoxDecoration(
        color:
            widget.individualDesignToken?.colorToken.backgroundColor.shade900 ??
                globalDesignToken.colorToken.backgroundColor.shade900,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: iconWidth,
            child: RtkSelfAudioToggleButton(meeting: rtkMeeting),
          ),
          SizedBox(
            width: iconWidth,
            child: RtkSelfVideoToggleButton(
              meeting: rtkMeeting,
              // showLabel: true,
            ),
          ),
          RtkScreenshareWidget(
            meeting: rtkMeeting,
          ),
          const MoreButtonWidget(),
          RtkLeaveButton(meeting: rtkMeeting),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    rtkMeeting.removeParticipantsEventListener(_audioNotifier);
    rtkMeeting.removeParticipantsEventListener(_videoNotifier);
    rtkMeeting.removeDataUpdateEventListener(stagePerms);
  }
}

class OnStageToggleWidget extends ConsumerStatefulWidget {
  final Widget child;
  const OnStageToggleWidget({super.key, required this.child});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnStageToggleWidgetState();
}

class _OnStageToggleWidgetState extends ConsumerState<OnStageToggleWidget> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(stageStatusNotifier) == StageStatus.onStage
        ? widget.child
        : const SizedBox.shrink();
  }
}

class _RtkStageControlBar extends ConsumerStatefulWidget {
  final RtkDesignTokens designToken;
  final bool canLivestream;
  final RtkDesignTokens? individualDesignToken;
  _RtkStageControlBar({
    this.individualDesignToken,
    this.canLivestream = false,
  }) : designToken = individualDesignToken ?? globalDesignToken;
  @override
  ConsumerState<_RtkStageControlBar> createState() =>
      _RtkStageControlBarState();
}

class _RtkStageControlBarState extends ConsumerState<_RtkStageControlBar> {
  late RtkDataEventListener stageDataListener;
  @override
  void initState() {
    stageDataListener = ref.read(stagePermissionNotifier.notifier);
    rtkMeeting.addDataUpdateEventListener(stageDataListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final iconWidth = (context.width - 8) / 8;

    return Container(
      height: context.adjust(bottomNavbarHeight + 6),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      decoration: BoxDecoration(
        color:
            widget.individualDesignToken?.colorToken.backgroundColor.shade900 ??
                globalDesignToken.colorToken.backgroundColor.shade900,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          const RtkStageRequestButton(),
          SizedBox(
            width: iconWidth,
            child: OnStageToggleWidget(
              child: RtkSelfAudioToggleButton(meeting: rtkMeeting),
            ),
          ),
          SizedBox(
            width: iconWidth,
            child: OnStageToggleWidget(
              child: RtkSelfVideoToggleButton(meeting: rtkMeeting),
            ),
          ),
          OnStageToggleWidget(
            child: RtkScreenshareWidget(
              meeting: rtkMeeting,
            ),
          ),
          MoreButtonWidget(
            canLivestream: widget.canLivestream,
          ),
          RtkLeaveButton(meeting: rtkMeeting),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    rtkMeeting.removeDataUpdateEventListener(stageDataListener);
  }
}
