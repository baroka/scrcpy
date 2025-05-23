#!/bin/sh
# Script for get FortiTokenMobile OTP

# Check available device
found=''
IFS=','; for DEVICE in $DEVICES; do 
  if ping -c 1 -W 1 "$DEVICE"; then
    echo "$DEVICE is alive"
    found='OK'
    break
  else
    echo "$DEVICE is not alive"
  fi
done
if [[ "$found" != "OK" ]]
then
	echo "No device available"
	exit 1
fi

# Connect to device
adb connect $DEVICE:$PORT

# Open FortiTokenMobile
package=com.fortinet.android.ftm
adb -s $DEVICE:$PORT shell am start $package/$(adb -s $DEVICE:$PORT shell cmd package resolve-activity -c android.intent.category.LAUNCHER $package | sed -n '/name=/s/^.*name=//p')

# Unlock screen
adb -s $DEVICE:$PORT shell input keyevent 26
adb -s $DEVICE:$PORT shell input touchscreen swipe 600 780 600 380

# Unhide OTP
adb -s $DEVICE:$PORT shell input tap 719 345

# Copy to clipboard
adb -s $DEVICE:$PORT shell input touchscreen swipe 355 356 355 356 1000

# Get clipboard
package=ca.zgrs.clipper
adb -s $DEVICE:$PORT shell am start $package/$(adb -s $DEVICE:$PORT shell cmd package resolve-activity -c android.intent.category.LAUNCHER $package | sed -n '/name=/s/^.*name=//p')
otp=`adb -s $DEVICE:$PORT shell am broadcast -a clipper.get | grep data= | awk -F'"' '{print $2}'`

# Lock screen
adb -s $DEVICE:$PORT shell input keyevent 26

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