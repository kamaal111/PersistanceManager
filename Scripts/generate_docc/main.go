package main

import (
	"log"
	"os"
	"os/exec"
)

func main() {
	xcodebuild := "/Applications/Xcode-beta.app/Contents/Developer/usr/bin/xcodebuild"
	buildDocumentationCommand := exec.Command(xcodebuild, "docbuild", "-scheme", "PersistanceManager", "-derivedDataPath", "DerivedData")
	_, err := buildDocumentationCommand.Output()
	if err != nil {
		log.Fatalln(err)
	}

	doccArchivePath := "DerivedData/Build/Products/Debug/PersistanceManager.doccarchive"
	_, err = os.Stat(doccArchivePath)
	if os.IsNotExist(err) {
		log.Fatalln(err)
	}

	err = copy(doccArchivePath, "PersistanceManager.doccarchive")
	if os.IsNotExist(err) {
		log.Fatalln(err)
	}
}

func copy(fromPath string, destination string) error {
	return os.Rename(fromPath, destination)
}
