#!/bin/sh

SCHEME="PersistanceManager"

time {
    rm -rf docs
    set -o pipefail && SCHEME="$SCHEME" go run Scripts/generate_docc/main.go || exit 1
    cd docc2html
    swift run docc2html "../$SCHEME.doccarchive" ../docs
}