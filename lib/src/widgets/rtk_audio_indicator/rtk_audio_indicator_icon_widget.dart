import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/data/notifiers/audio_notifier.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/utils/generate_key.dart';
import 'package:flutter/material.dart';

class RtkAudioIndicatorIconWidget extends StatefulWidget {
  final RtkMeetingParticipant participant;
  final double? iconSize;

  const RtkAudioIndicatorIconWidget({
    super.key,
    required this.participant,
    this.iconSize,
  });

  bool get isLocalUser => participant.id == rtkMeeting.localUser.id;

  @override
  State<RtkAudioIndicatorIconWidget> createState() => _AudioIconState();
}

class _AudioIconState extends State<RtkAudioIndicatorIconWidget> {
  LocalUserAudioNotifier? _localUserAudioNotifier;
  AudioNotifier? _audioNotifier;
  late final bool _isLocalUser;

  @override
  void initState() {
    super.initState();
    _isLocalUser = widget.isLocalUser;

    if (_isLocalUser) {
      _localUserAudioNotifier = LocalUserAudioNotifier();
      rtkMeeting.addSelfEventListener(_localUserAudioNotifier!);
    } else {
      _audioNotifier = AudioNotifier(widget.participant);
      rtkMeeting.addParticipantsEventListener(_audioNotifier!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    if (_isLocalUser) {
      return ValueListenableBuilder(
        valueListenable: _localUserAudioNotifier!,
        builder: (context, bool audioEnabled, child) {
          return Icon(
            audioEnabled ? DyteIcons.mic_on : DyteIcons.mic_off,
            key: generateAudioKeyForParticipant(
              widget.participant,
              pageName: 'AudioIcon',
            ),
            size: widget.iconSize ?? 24,
            color: audioEnabled
                ? theme.colorScheme.onSecondary
                : theme.colorScheme.error,
          );
        },
      );
    } else {
      return ValueListenableBuilder(
        valueListenable: _audioNotifier!,
        builder: (context, bool audioEnabled, child) {
          return Icon(
            audioEnabled ? DyteIcons.mic_on : DyteIcons.mic_off,
            key: generateAudioKeyForParticipant(
              widget.participant,
              pageName: 'AudioIcon',
            ),
            size: widget.iconSize ?? 24,
            color: audioEnabled
                ? theme.colorScheme.onSecondary
                : theme.colorScheme.error,
          );
        },
      );
    }
  }

  @override
  void dispose() {
    if (_localUserAudioNotifier != null) {
      rtkMeeting.removeSelfEventListener(_localUserAudioNotifier!);
    }
    if (_audioNotifier != null) {
      rtkMeeting.removeParticipantsEventListener(_audioNotifier!);
    }
    super.dispose();
  }
}
