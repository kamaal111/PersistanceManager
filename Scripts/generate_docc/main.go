package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
)

func main() {
	SCHEME := os.Getenv("SCHEME")
	if SCHEME == "" {
		log.Fatalln("No scheme provided")
	}

	xcodebuild := "/Applications/Xcode-beta.app/Contents/Developer/usr/bin/xcodebuild"
	buildDocumentationCommand := exec.Command(xcodebuild, "docbuild", "-scheme", SCHEME, "-derivedDataPath", "DerivedData")
	_, err := buildDocumentationCommand.Output()
	if err != nil {
		log.Fatalln(err)
	}

	doccArchivePath := fmt.Sprintf("DerivedData/Build/Products/Debug/%s.doccarchive", SCHEME)
	_, err = os.Stat(doccArchivePath)
	if os.IsNotExist(err) {
		log.Fatalln(err)
	}

	err = copy(doccArchivePath, fmt.Sprintf("%s.doccarchive", SCHEME))
	if os.IsNotExist(err) {
		log.Fatalln(err)
	}
}

func copy(fromPath string, destination string) error {
	return os.Rename(fromPath, destination)
}
