# RealtimeKit UI for Flutter Mobile

An easy-to-integrate Flutter package for all your audio-video call, and does all the heavylifting using state-of-the-art Cloudflare's RealtimeKit and infrastructure.

A following example showcases some of the screens you get with this package:

<table>
    <tbody>
        <tr>
            <td align="center" style="background-color: white">
                <img src="https://cdn.dyte.in/flutter_uikit/flutter-setup-page.png" width="225"/>
            </td>
            <td align="center" style="background-color: white">
                <img src="https://cdn.dyte.in/flutter_uikit/flutter-video-call.png" width="225"/>
            </td>
            <td align="center" style="background-color: white">
                <img src="https://cdn.dyte.in/flutter_uikit/flutter-advanced-features.png" width="225"/>
            </td>
        </tr>
        <tr>
            <td align="center" style="background-color: white">
                <img src="https://cdn.dyte.in/flutter_uikit/flutter-chat.png" width="225"/>
            </td>
            <td align="center" style="background-color: white">
                <img src="https://cdn.dyte.in/flutter_uikit/flutter-participant-list.png" width="225"/>
            </td>
        </tr>
    </tbody>
</table>

## Before getting started:
Make sure you've read the [Getting Started with RealtimeKit](https://docs.realtime.cloudflare.com/getting-started) guide and completed the steps in the [Integrate RealtimeKit](https://docs.realtime.cloudflare.com/getting-started#integrate-realtimekit) section which includes:
- Creating a [RealtimeKit Developer Account](https://dash.realtime.cloudflare.com)

- Creating [Presets](https://dash.realtime.cloudflare.com/presets)

> **_Presets:_**  Set of permissions and UI configurations that are applied to participants.

- Creating a [RealtimeKit Meeting](https://docs.realtime.cloudflare.com/api#/operations/create_meeting)

- [Adding a Participant](https://docs.realtime.cloudflare.com/api#/operations/add_participant) to the meeting

After adding a participant to your meeting, you'll receive an `authToken`. That's all you require to prepare a complete RealtimeKit video-audio meeting.

## Usage

### Step 1: Install the SDK

- Add `realtimekit_ui` as a dependency in your `pubspec.yaml`, or run `flutter pub add realtimekit_ui`.

```bash
flutter pub add realtimekit_ui
```

### Step 2: Android & iOS Permissions

- #### Android

    Set `compileSdkVersion 36` & `minSdkVersion 24` inside app-level `build.gradle`.

    ```groovy

    defaultConfig {
        ...

        compileSdkVersion 36
        minSdkVersion 24

        ...
    }
    ```

- #### iOS

    1. Set minimum deployment target for your Flutter app to 13.0 or higher in your Podfile.

    ```Swift
    platform :ios, '13.0'
    ```

    2. Add the following keys to your `Info.plist` file to get Camera & Microphone permission.

    ```xml
    <!-- Add the permission to use camera & microphone. -->

    <key>NSCameraUsageDescription</key>
    <string>For people to see you during meetings, we need access to your camera.</string>
    
    <key>NSMicrophoneUsageDescription</key>
    <string>For people to hear you during meetings, we need access to your microphone.</string>
    ```

### Step 3: Initialize the SDK

Create the `RtkMeetingInfo` object using the `authToken` you fetched from [Before Getting Started](#before-getting-started) section as follows:

```dart
    final meetingInfo = RtkMeetingInfo(authToken: '<auth_token>');
```

Initialize the RealtimeKitUI with the `RealtimeKitUIBuilder` class, using the meetingInfo configured above.

```dart

/* Passing the RtkMeetingInfo object `meetingInfo` you created in the Step 3 */

final realtimeKitUIInfo = RealtimeKitUIInfo(
      meetingInfo,
      // Optional: Pass the RtkDesignTokens object to customize the UI
      designToken: RtkDesignTokens(
        colorToken: RtkColorToken(
          brandColor: Colors.purple,
          backgroundColor: Colors.black,
          textOnBackground: Colors.white,
          textOnBrand: Colors.white,
        ),
      ),
    );

final realtimeKitUI = RealtimeKitUIBuilder.build(uiKitInfo: uikitInfo);

```

### Step 4: Launch the meeting UI

To launch the meeting UI all you need to do is call the `loadUI()` method of the `RealtimeKitUI` object which will return a `Widget`. You can push this widget as a page to start the flow of prebuilt Flutter UI Kit.

```dart
    import 'package:realtimekit_ui/realtimekit_ui.dart';
    import 'package:flutter/material.dart';

    class RtkMeetingPage extends StatelessWidget {
      const RtkMeetingPage({super.key});
    
      @override
      Widget build(BuildContext context) {
        ...
        // Push this widget as page in your app
        return realtimeKitUI.loadUI();
      }
    }
```

### Conclusion

To know more about the customization you can do with `realtimekit_ui`, head over to our [Flutter docs](`https://docs.realtime.cloudflare.com/flutter).

### Sample app

You can clone our [sample app](https://github.com/dyte-io/mobile-samples/tree/main/flutter_uikit) to get more idea about the implementation of `realtimekit_ui` in Flutter application.
