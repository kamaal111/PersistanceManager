#!/bin/sh


project="PersistanceManager.xcodeproj"
scheme="PersistanceManager-Package"

destinations=(
  "platform=macOS"
  "platform=iOS Simulator,name=iPhone 11 Pro Max"
)

xcode_test() {
  set -o pipefail && xcodebuild test -project "$project" -scheme "$1" -destination "$2" | xcpretty || exit 1
}

test_all_destinations() {
  time {
    for destination in "${destinations[@]}"
    do
      xcode_test "$scheme" "$destination"
    done
  }
}

test_all_destinations