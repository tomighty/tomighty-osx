#!/usr/bin/env bash

set -e

mkdir -p target
xcodebuild -project ../src/Tomighty.xcodeproj -archivePath target/Tomighty -scheme Tomighty archive
xcodebuild -exportArchive -exportFormat APP -archivePath target/Tomighty.xcarchive -exportPath target/Tomighty
