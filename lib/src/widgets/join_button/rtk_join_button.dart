import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:flutter/material.dart';
import 'package:realtimekit_ui/src/widgets/core/button/rtk_button_controller.dart';
import 'package:realtimekit_ui/src/widgets/core/core.dart';

class RtkJoinButton extends StatefulWidget {
  const RtkJoinButton({
    required this.meeting,
    this.rtkDesignToken,
    super.key,
    this.onMeetingJoined,
    this.height,
    this.width,
    this.isDisabled = false,
  });

  final VoidCallback? onMeetingJoined;
  final RtkDesignTokens? rtkDesignToken;
  final RealtimekitClient meeting;
  final double? height;
  final double? width;
  final bool isDisabled;

  @override
  State<RtkJoinButton> createState() => _RtkJoinButtonState();
}

class _RtkJoinButtonState extends State<RtkJoinButton> {
  final RtkButtonController _buttonController = RtkButtonController();
  late final JoinButtonNotifier _joinButtonNotifier;

  @override
  void initState() {
    _joinButtonNotifier = JoinButtonNotifier(_buttonController);
    widget.meeting.addMeetingRoomEventListener(_joinButtonNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RtkButtons.solid(
      height: widget.height,
      width: widget.width,
      label: 'Join',
      onPressed: widget.isDisabled
          ? null
          : () {
              widget.meeting.joinRoom();
              widget.onMeetingJoined?.call();
            },
      controller: _buttonController,
    );
  }

  @override
  void dispose() {
    widget.meeting.removeMeetingRoomEventListener(_joinButtonNotifier);
    _joinButtonNotifier.dispose();
    super.dispose();
  }
}

class JoinButtonNotifier extends ValueNotifier<JoinMeetingState>
    implements RtkMeetingRoomEventListener {
  final RtkButtonController _buttonController;
  JoinButtonNotifier(this._buttonController) : super(JoinMeetingInitial());

  @override
  void onMeetingRoomJoinStarted() {
    value = JoinMeetingLoading();
    _buttonController.changeState(ButtonState.loading);
  }

  @override
  void onMeetingRoomJoinCompleted() {
    value = JoinMeetingSuccess();
    _buttonController.changeState(ButtonState.complete);
  }

  @override
  void onMeetingRoomJoinFailed(Exception exception) {
    value = JoinMeetingError();
    _buttonController.changeState(ButtonState.disabled);
  }

  @override
  void onMeetingInitCompleted() {}

  @override
  void onMeetingInitFailed(Exception exception) {}

  @override
  void onMeetingInitStarted() {}

  @override
  void onMeetingRoomLeaveCompleted() {}

  @override
  void onMeetingRoomLeaveStarted() {}

  @override
  void onActiveTabUpdate(ActiveTab? activeTab) {}

  @override
  void onMeetingEnded() {}

  @override
  void onSocketConnectionUpdate(SocketConnectionState state) {
    // TODO: implement onSocketConnectionUpdate
  }
}

abstract class JoinMeetingState {}

class JoinMeetingInitial extends JoinMeetingState {}

class JoinMeetingLoading extends JoinMeetingState {}

class JoinMeetingSuccess extends JoinMeetingState {}

class JoinMeetingError extends JoinMeetingState {}
