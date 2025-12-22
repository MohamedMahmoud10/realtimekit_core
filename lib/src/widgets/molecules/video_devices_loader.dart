import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/widgets/molecules/peer_video_devices_dropdown.dart';
import 'package:flutter/material.dart';

class VideoDevicesLoader extends StatelessWidget {
  const VideoDevicesLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: rtkMeeting.localUser.getVideoDevices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          final List<VideoDevice> videoDevices =
              snapshot.data as List<VideoDevice>;
          return FutureBuilder(
            future: rtkMeeting.localUser.getSelectedVideoDevice(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final selectedVideoDevice = snapshot.data as VideoDevice;
                return PeerVideoDevicesDropDown(
                  videoDevices: videoDevices,
                  selectedVideoDevice: selectedVideoDevice,
                );
              } else {
                return Container();
              }
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
