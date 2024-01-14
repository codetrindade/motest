# moveme

A new Flutter application.

## Getting Started

flutter build apk --release --target-platform android-arm,android-arm64,android-x64

flutter build appbundle --target-platform android-arm,android-arm64,android-x64

flutter build ios --release --no-codesign

## Generate models
flutter packages pub run build_runner build --delete-conflicting-outputs