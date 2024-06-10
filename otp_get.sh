#!/bin/sh
# Script for get FortiTokenMobile OTP

# Connect to device
adb connect $DEVICE:$PORT

# Open FortiTokenMobile
package=com.fortinet.android.ftm
adb shell am start $package/$(adb shell cmd package resolve-activity -c android.intent.category.LAUNCHER $package | sed -n '/name=/s/^.*name=//p')

# Unlock screen
#adb shell input keyevent 26
#adb shell input touchscreen swipe 600 780 600 380

# Unhide OTP
adb shell input tap 719 345

# Copy to clipboard
adb shell input touchscreen swipe 355 356 355 356 1000

# Get clipboard
package=ca.zgrs.clipper
adb shell am start $package/$(adb shell cmd package resolve-activity -c android.intent.category.LAUNCHER $package | sed -n '/name=/s/^.*name=//p')
otp=`adb shell am broadcast -a clipper.get | grep data= | awk -F'"' '{print $2}'`

# Lock screen
adb shell input keyevent 26

# Disconnect device
adb disconnect

# Update config file with OTP
echo "OTP code is $otp"

config="/scrcpy/config"
temp="/tmp/config"
param="otp = "

if [ -n "$otp" ]; then
	cp $config $temp
	sed -i "/^$param/c\\$param$otp" $temp
	cp -f $temp $config
fi