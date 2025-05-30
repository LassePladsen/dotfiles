#!/usr/bin/bash
device=$(adb devices | grep tcp)
# Split by whitespace and get first, which is the device id to use
devicearr=($device)
id=${devicearr[0]}
targetfile="/home/lasse/work/local/flightpark/flightparkapp/android/app/build/outputs/apk/release/app-release.apk"
if [ -n "$id" ]; then
    echo "INSTALLING $targetfile ON DEVICE: $id"
    adb -s $id install $targetfile
else
    echo "No physical device found"
    exit 1
fi
