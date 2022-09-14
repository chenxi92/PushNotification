#! /bin/bash

set -x
set -e

AppName="PushNotification"
VolumeName="PushNotificationInstaller"

xcodebuild build -configuration Release

# make sure .app file exist
test -d ./build/Release/${AppName}.app || exit 1

# if the target dmg file exist, remove it
test -f ${AppName}.dmg && rm ${AppName}.dmg

hdiutil create -megabytes 54 -fs HFS+ -volname ${VolumeName} ${AppName}.dmg
hdiutil mount ${AppName}.dmg

cp -r ./build/Release/${AppName}.app /Volumes/${VolumeName}
