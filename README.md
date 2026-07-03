# realtimekit_core

<!-- PROJECT LOGO -->
<p align="center">
  <a href="https://realtime.cloudflare.com/">
    <img src="https://docs.realtime.cloudflare.com/logo/cf.svg" alt="Logo" width="80">
  </a>
  <h3 align="center">RealtimeKit Core for Flutter Mobile</h3>

  <p align="center">
    A SDK that provides Cloudflare Realtime's audio, video conferencing and livestreaming functionality.
    <br />
    <a href="https://docs.realtime.cloudflare.com/flutter-core"><strong>Explore the docs »</strong></a>
    <br />
  </p>
</p>

## Before Getting Started

- Make sure you've read the
  [Getting Started with RealtimeKit](https://docs.realtime.cloudflare.com/getting-started) topic and
  completed the steps in the
  [Integrate RealtimeKit](https://docs.realtime.cloudflare.com/getting-started#integrate-realtimekit) section.
  You must complete the following steps:
  - Create a [RealtimeKit Developer Account](https://dash.realtime.cloudflare.com)
  - Create [Presets](https://dash.realtime.cloudflare.com/presets)
  - Create a
    [RealtimeKit Meeting](https://docs.realtime.cloudflare.com/api#/operations/create_meeting)
  - [Add a Participant](https://docs.realtime.cloudflare.com/api#/operations/add_participant)
    to the meeting

## Installation

```sh
flutter pub add realtimekit_core
```

### For iOS

1. Set your platform to iOS 12.0 or above in your Podfile.

```dart
platform :ios, '12.0'
```

2. Add the following entries to the `info.plist` file. This gives permission to
   your app to access the camera and microphone, access photos, install the
   required fonts and icons.

```dart
<key>NSBluetoothPeripheralUsageDescription</key>
<string>We will use your Bluetooth to access your Bluetooth headphones.</string>
<key>NSBluetoothAlwaysUsageDescription</key>
<string>We will use your Bluetooth to access your Bluetooth headphones.</string>
<key>NSCameraUsageDescription</key>
<string>For people to see you during meetings, we need access to your camera.</string>
<key>NSMicrophoneUsageDescription</key>
<string>For people to hear you during meetings, we need access to your microphone.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>For people to share, we need access to your photos.</string>
```

<!-- USAGE EXAMPLES -->
## Usage

### Import the following package into your project:

```dart
import 'package:realtimekit_core/realtimekit_core.dart';
```

### Initialize the SDK

The `RealtimeKitClient` is the main class of the SDK. It is the entry point and
the only class required to initialize RealtimeKit SDK.

```dart
final meeting = RealtimeKitClient();
```

### Set the meeting properties

Set the properties in the `RtkMeetingInfo` class. You just need to provide the
participant's `authToken`.

| Name        | Description                                                                                                                                                                                                                                                                                                                                   |
| ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `authToken` | After you've created the meeting, <br/> add each participant to the meeting <br/> using the [Add Participant API](https://docs.realtime.cloudflare.com/api#/operations/add_participan)<br/> (The presetName created earlier <br/> must be passed in the body <br/> of the Add Participant API request) <br/> The API response contains the `authToken`. |

```dart
final meetingInfo = RtkMeetingInfo(
                    authToken: '<auth_token>',
                  );
```

### Initialize the connection request

To initialize the connection request, call the `init()` method on
`RealtimeKitClient` object with the `meetingInfo` argument. This will establish the connection
with the RealtimeKit meeting server.

```dart
meeting.init(meetingInfo);
```

By registering state observers, you receive callbacks for this action on the
meeting object.

```dart

class RoomStateNotifier extends RtkMeetingRoomEventListener {

  ...

  @override
  void onMeetingInitStarted() {
    /// on meeting init started
  }

  override
  void onMeetingInitCompleted() {
    /// on meeting init completed
  }

  @override
  void onMeetingInitFailed(Exception exception) {
    /// on meeting init failed
  }

  ...
}

```

### Connect to the meeting

Now, you have established the connection with the RealtimeKit meeting server
successfully. Next step is to join the room.

#### Join the room

To join the meeting room, call `joinRoom()` method on the `RealtimeKitClient` instance
as shown below.

```dart
meeting.joinRoom();
```

By registering state observers, you receive callbacks for this action on the
meeting object.

```dart
class LocalUserStatesNotifier extends RtkSelfEventListener {

  @override
  void onMeetingRoomJoinStarted() {
    /// Handle join start state
  }

  @override
  void onMeetingRoomJoined () {
    /// Handle joining completion, ex: move to room screen
  }

  @override
  void onMeetingRoomJoinFailed(exception){
    /// Handle failure
  }

}
```

#### Leave the room

Once the meeting is over, you can leave the meeting room.

To leave the meeting room, call `leaveRoom()` method on the `RealtimeKitClient` as
shown below.

```dart
meeting.leaveRoom();
```

### Cleanup listeners

Call the `cleanAllNativeListeners()` method when you're done with current session of RealtimeKit meeting. It interally calls individual new clean methods for each listener `cleanNativeMeetingRoomEventsListener()`, `cleanNativeParticipantEventListener()`, `cleanNativePollListener()`, `cleanNativeRecordingListener()`, `cleanNativeStageEventsListener()`, `cleanNativeSelfParticipantEventListener()`, `cleanNativeChatListener()`, `cleanNativeDataUpdateListener()`, `cleanNativeLivestreamListener()`, `cleanNativePluginEventsListener()`.

By registering state observers, you receive callbacks for this action on the
meeting object.

```dart
class RoomStateNotifier extends RtkMeetingRoomEventListener {

  ...

  @override
  void onMeetingRoomLeaveStarted() {
    /// on meeting room leave started
  }

  @override
  void onMeetingRoomLeaveCompleted() {
    meeting.removeMeetingRoomEventListener(this);
    meeting.cleanupAppListeners();

    /// on meeting room left
  }

  ...

}
```

_For more examples, please refer to the [Documentation](https://docs.realtime.cloudflare.com/flutter-core)._

## About

`realtimekit_core` is created & maintained by Cloudflare, Inc. You can find us on X - [@Cloudflare](https://x.com/cloudflare) or chat with us from your [Developer accout](https://dash.realtime.cloudflare.com).

The names and logos for Cloudflare are trademarks of Cloudflare, Inc.

We love open source software! See [our other projects](https://github.com/dyte-in) and [our products](https://www.cloudflare.com/).


