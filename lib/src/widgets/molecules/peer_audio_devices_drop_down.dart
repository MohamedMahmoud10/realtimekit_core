import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';

class PeerAudioDevicesDropDown extends ConsumerStatefulWidget {
  final List<AudioDevice> audioDevices;
  final AudioDevice selectedAudioDevice;
  const PeerAudioDevicesDropDown({
    super.key,
    required this.audioDevices,
    required this.selectedAudioDevice,
  });

  @override
  ConsumerState<PeerAudioDevicesDropDown> createState() =>
      _PeerDevicesDropDownState();
}

class _PeerDevicesDropDownState
    extends ConsumerState<PeerAudioDevicesDropDown> {
  AudioDeviceType? selectedAudioDeviceType;

  @override
  void initState() {
    selectedAudioDeviceType = widget.selectedAudioDevice.type;
    super.initState();
  }

  String _getLocaleDeviceName(AudioDeviceType audioDevice) {
    switch (audioDevice) {
      case AudioDeviceType.wired:
        return RtkStrings.headset;
      case AudioDeviceType.speaker:
        return RtkStrings.speaker;
      case AudioDeviceType.bluetooth:
        return RtkStrings.bluetooth;
      case AudioDeviceType.earpiece:
        return RtkStrings.earpiece;
      case AudioDeviceType.unknown:
        return RtkStrings.speaker;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return DropdownButton(
      isExpanded: MediaQuery.of(context).orientation == Orientation.portrait,
      icon: const Icon(
        DyteIcons.chevron_down,
      ),
      iconEnabledColor: textColorSwatch.shade1000,
      iconSize: 18,
      dropdownColor: theme.colorScheme.primaryContainer,
      value: selectedAudioDeviceType,
      hint: RtkText(
        RtkStrings.selectAudioDevice,
      ),
      items: widget.audioDevices
          .map(
            (AudioDevice audioDevice) => DropdownMenuItem<AudioDeviceType>(
              value: audioDevice.type,
              child: RtkText(
                _getLocaleDeviceName(audioDevice.type),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value == null) return;

        final selectedDevice = widget.audioDevices.firstWhere(
          (device) => device.type == value,
        );

        selectedAudioDeviceType = value;
        setState(() {});

        rtkMeeting.localUser.setAudioDevice(selectedDevice);
      },
    );
  }
}
