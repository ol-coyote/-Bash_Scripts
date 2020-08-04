#!/bin/bash
echo "Configuring a wifi adapter to connect to wifi from a terminal"
echo
echo "Checking network interface name:"

NAME=`ls /sys/class/ieee80211/*/device/net/`
if [ $NAME ]
then
    echo "$NAME found, continuing!"
else
    echo "Interface not found!"
    exit 1;
fi
echo

echo "Checking $NAME link status: `iw $NAME link`"
echo
echo "Bringing $NAME link up"
ifconfig $NAME down && ifconfig $NAME up;
wait $!;
echo

echo "Searching for wireless APs using interface $NAME, found:"
iw $NAME scan | grep -i "ssid:" 2>&1;
wait $!;
echo

echo "Enter SSID to connect to:"
read SSID
echo
echo "Enter passphrase (leave blank for none)"
read PASSPHRASE
echo


if test -z "$PASSPHRASE"
then
    echo "connecting to: $SSID"
    nmcli dev wifi connect $SSID;
    wait $!;
else
    nmcli dev wifi connect $SSID password $PASSPHRASE
fi
echo
echo "Connection details:"
echo `ifconfig $NAME | grep -i inet`

