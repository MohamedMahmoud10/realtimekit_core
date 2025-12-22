<!-- PROJECT LOGO -->
<p align="center">
 <a href="https://dyte.io">
   <img src="https://assets.dyte.io/logo-outlined.png" alt="Logo" width="120" />
 </a>
 <h2 align="center">Dyte's UI Kit SDK for Flutter apps</h2>
</p>

This SDK provides prebuilt design library of UI components that makes it easy to integrate video and voice calls into any Flutter app within minutes. Clients can integrate this SDK in their apps and build their own, fully custom experiences on top of it using the components, as per their requirement.

The project uses Dyte's in-house [Flutter Core](https://pub.dev/packages/dyte_core) SDK under the hood to target both Android & iOS platforms. It also has a sample app for testing the APIs and features on Android & iOS:

- [Flutter UI Kit Sample App](https://github.com/dyte-in/flutter-ui-kit/tree/main/example)

## Installation and Getting Started

Refer the Quickstart pages of the [Flutter](https://docs.dyte.io/flutter) documentation.

## Public Samples

We also maintain public sample apps in the following repository:

- [dyte-io/flutter-samples](https://github.com/dyte-io/flutter-samples/tree/main/flutter_uikit)

## Running the SDK

### Pre-requisites

1. Follow [this Notion guide](https://www.notion.so/dyte/M1-Mac-setup-guide-for-Mobile-team-cfc6f0f49437410ab041b240d3a36b6a?pvs=4) to setup
your Apple Silicon machine.
2. Clone the repository:

```shell
git clone git@github.com:dyte-in/flutter-ui-kit.git
```

3. Open the **flutter-ui-kit** project folder in your Code Editor (VSCode, Android Studio, etc.).

We suggest publishing/generating/ SDK locally and running it with the UIKits.

### Running the app

#### Setup for iOS

- Change the current directory to /flutter-ui-kit/example/ios/.

- Run the following command to install the pods:

```shell
 pod repo --update
 pod install
```

1. Paste your participant auth-token in the `example` [lib/main.dart](/example/lib/main.dart#L43).
2. Change VS Code's run configuration to `example` and run `flutter run`.

## Testing local changes

You can use the Flutter UI Kit SDK your local realtimekit_ui version by changing the path of `realtimekit_ui` in `pubspec.yaml` files and adding the `publish_to: none` in all yaml files.:

```yaml
// whatever your package name is
package: dyte_app
// Add this line for testing locally
// else, remove it before publishing
publish_to: none

dependencies:
  flutter:
    sdk: flutter
  realtimekit_ui:
    path: ../
```

## Publishing the package

1. Make a new branch out of `staging`
2. Remove the `publish_to: none` line from all the `pubspec.yaml` files, and remove all the path to dependencies and replace their version number to latest versions.

3. Change the directory to root of the project i.e. `flutter-ui-kit/`

4. Once the changes are made, run the following command to check the next version by [Internal Semantic Release Tool](https://github.com/dyte-in/semantic-release-flutter-plugin). You can set run this tool by running the following command:

> **_NOTE:_**
_Merge the change branch to `main` locally and run the following command on local `main` branch. Reset the main branch once you know analyze the version._


```shell
npx semantic-release --no-ci --dry-run
```

This should give you the next release version for current set of changes commited.

5. Push the changes to the branch along with updating [CHANGELOG](/CHANGELOG.md) against the potential next release version, merge the branch to `staging` branch. 

6. Upon merging `staging` to `main`, GitHub actions shall publish the package to pub.dev.

The package should be published! 🎉
