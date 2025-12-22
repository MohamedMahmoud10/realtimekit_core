import 'package:realtimekit_core_platform_interface/src/types/errors/rtk_error.dart';
import 'package:realtimekit_core_platform_interface/src/types/rtk_audio_device.dart';
import 'package:realtimekit_core_platform_interface/src/types/rtk_video_device.dart';

abstract class RtkLocalUserApi {
  Future<void> enableAudio({OnResult? onResult});
  Future<void> disableAudio({OnResult? onResult});
  Future<void> enableVideo({OnResult? onResult});
  Future<void> disableVideo({OnResult? onResult});
  Future<void> setDisplayName(String name);
  Future<List<AudioDevice>> getAudioDevices();
  Future<List<VideoDevice>> getVideoDevices();
  Future<void> setAudioDevice(AudioDevice device);
  Future<void> setVideoDevice(VideoDevice device);
  Future<AudioDevice?> getSelectedAudioDevice();
  Future<VideoDevice?> getSelectedVideoDevice();
  void switchCamera();
  void enableScreenshare();
  void disableScreenshare();
}
