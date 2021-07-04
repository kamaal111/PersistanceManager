#!/bin/sh

time {
    rm -rf docs
    go run Scripts/generate_docc/main.go
    cd docc2html
    swift run docc2html ../PersistanceManager.doccarchive ../docs
}