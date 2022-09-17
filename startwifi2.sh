#!/bin/bash
ssid=$(grep '#ssid' /boot/wpa_supplicant.conf | cut -d '"' -f2)
if [ -z "$ssid" ]; then
        ssid=$(grep -m1 'ssid=' /boot/wpa_supplicant.conf |  cut -d '"' -f 2 )
        psk=$(grep -m 1 'psk=' /boot/wpa_supplicant.conf | cut -d '"' -f 2 )
else
        psk=$(grep '#psk' /boot/wpa_supplicant.conf | cut -d '"' -f 2 )
fi


nmcli dev wifi | grep "$ssid" &> /dev/null


ssid1="$ssid"
psk1="$psk"


        Host=$(ls /etc/NetworkManager/system-connections/ | grep "$ssid1")
        if [ -z "$Host" ]; then
                sudo nmcli dev wifi connect "$ssid1" password "$psk1" &> /dev/null
        else
                sudo nmcli con up "$ssid1" &> /dev/null
        fi




