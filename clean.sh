#!/bin/sh


flutter clean \ 
cd example/ios && rm -rf .symlinks && rm -rf Pods && rm -rf podspec.lock && pod install --repo-update && cd ../.. && \
flutter pub get