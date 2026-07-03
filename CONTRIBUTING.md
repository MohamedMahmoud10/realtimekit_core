# Contributing

Contributions should be made via pull requests to the `staging` branch of the repository.

## Building the SDK

Flutter UI Kit is built on top of [Flutter Core](https://pub.dev/packages/dyte_core/). Since it is multiplatform, we use MacOS to build the SDK for both Android & iOS. Follow [this Notion guide](https://www.notion.so/dyte/M1-Mac-setup-guide-for-Mobile-team-cfc6f0f49437410ab041b240d3a36b6a?pvs=4) to setup your Apple Silicon machine.

## Pull Requests

1. Create a new branch from `staging`.
2. Name your branch as `<your-name-initials>/<issue-ID>-<change-title>` (e.g `sm/MOB-123-participantcontroller-refactor`). You can also add `issue ID` as suffix instead of prefix
3. Break the work into small & progressive commits but ensure each commit builds the project
4. Create a new PR to merge your changes into the `staging` branch
5. Ensure that the description provides clear overview/explanation of the changes done
6. Make sure your code builds and passes the github actions

## Coding Style

We use default formatter settings for Dart. Ensure your code is formatted before committing.

## Commit Messages

1. Follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification. Include the scope/module name when possible
2. If your commit requires additional details, split the message into a subject and body. Separate subject from body with a blank line
3. Limit the subject line to 50 characters
4. Use the imperative mood in the subject line (e.g. "add" instead of "added") ([learn more](https://cbea.ms/git-commit/#imperative))
5. Include `issue ID` (eg. MOB-123) with appropriate [magic word](https://linear.app/docs/github?tabs=206cad22125a#link-using-pull-requests) in the message footer to link them to respective Linear tickets (e.g. `fixes: MOB-123`)

**NOTE**: For internal additions, changes use commit types with "**i**" prefix: `ifeat`, `ifix` etc.

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
