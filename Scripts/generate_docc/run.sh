#!/bin/sh

SCHEME="PersistanceManager"
XCODE_PATH="/Applications/Xcode-beta.app"

time {
    rm -rf docs
    set -o pipefail && SCHEME="$SCHEME" XCODE_PATH="$XCODE_PATH" go run Scripts/generate_docc/main.go || exit 1
    cd docc2html
    set -o pipefail && swift run docc2html "../$SCHEME.doccarchive" ../docs || exit 1
}