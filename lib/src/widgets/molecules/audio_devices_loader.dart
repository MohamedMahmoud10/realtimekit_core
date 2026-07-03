import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/widgets/molecules/peer_audio_devices_drop_down.dart';
import 'package:flutter/material.dart';

class AudioDevicesLoader extends StatelessWidget {
  const AudioDevicesLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: rtkMeeting.localUser.getAudioDevices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          final List<AudioDevice> audioDevices =
              snapshot.data as List<AudioDevice>;
          return FutureBuilder(
              future: rtkMeeting.localUser.getSelectedAudioDevice(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final selectedAudioDevice = snapshot.data as AudioDevice;

                  return PeerAudioDevicesDropDown(
                    audioDevices: audioDevices,
                    selectedAudioDevice: selectedAudioDevice,
                  );
                } else {
                  return Container();
                }
              });
        } else {
          return Container();
        }
      },
    );
  }
}
