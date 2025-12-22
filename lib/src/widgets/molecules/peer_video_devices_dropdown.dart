import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';

class PeerVideoDevicesDropDown extends ConsumerStatefulWidget {
  final List<VideoDevice> videoDevices;
  final VideoDevice selectedVideoDevice;
  const PeerVideoDevicesDropDown({
    super.key,
    required this.videoDevices,
    required this.selectedVideoDevice,
  });

  @override
  ConsumerState<PeerVideoDevicesDropDown> createState() =>
      _PeerVideoDevicesDropDownState();
}

class _PeerVideoDevicesDropDownState
    extends ConsumerState<PeerVideoDevicesDropDown> {
  late VideoDevice selectedVideoDevice;

  @override
  void initState() {
    selectedVideoDevice = widget.selectedVideoDevice;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      isExpanded: MediaQuery.of(context).orientation == Orientation.portrait,
      icon: const Icon(
        DyteIcons.chevron_down,
      ),
      iconEnabledColor: textColorSwatch.shade1000,
      iconSize: 18,
      hint: RtkText(
        RtkStrings.selectVideoDevice,
      ),
      value: selectedVideoDevice,
      items: widget.videoDevices
          .map(
            (VideoDevice videoDevice) => DropdownMenuItem<VideoDevice>(
              onTap: () async {
                if (videoDevice == selectedVideoDevice) {
                  return;
                } else {
                  await rtkMeeting.localUser.setVideoDevice(videoDevice);
                }
              },
              value: videoDevice,
              child: RtkText(videoDevice.toString()),
            ),
          )
          .toList(),
      onChanged: (value) async {
        if (value != selectedVideoDevice) {
          selectedVideoDevice = value as VideoDevice;
          setState(() {});
        }
      },
    );
  }
}
