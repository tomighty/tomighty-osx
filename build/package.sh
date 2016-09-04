#!/usr/bin/env bash

#Us the create-dmg project to create the DMG
#git clone https://github.com/andreyvit/yoursway-create-dmg.git

VERSION=1.1

yoursway-create-dmg/create-dmg \
    --volname "Tomighty-$(VERSION)" \
    --icon-size 75 \
    --app-drop-link 10 10 \
    --icon target/package/Tomighty.app 95 10 \
    target/Tomighty-$(VERSION).dmg \
    target/package
