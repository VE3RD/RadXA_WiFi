#!/bin/bash



echo "Finding Active Connection"
 ssid=$(nmcli connection | grep wlan0 | cut -d " " -f1)
echo  "Active Connection = $ssid"


## Delete all hotspot config files
echo "Deleting any exiting hotspot files"
sudo rm /etc/NetworkManager/system-connections/hotspot*

##Restart NetworkManager.service
echo "5 Second Delay"
systemctl restart NetworkManager.service
sleep 5


#Create New Hotspot config file
echo "creating New Hotspot Config File"
sudo nmcli con add type wifi ifname wlan0 con-name hotspot autoconnect yes ssid RadXA
sudo nmcli con modify hotspot 802-11-wireless.mode ap 802-11-wireless.band bg
sudo nmcli con modify hotspot ipv4.addresses 192.168.50.1/29
sudo nmcli con mod hotspot ipv4.method manual
sudo nmcli con modify hotspot wifi-sec.key-mgmt wpa-psk
sudo nmcli con modify hotspot wifi-sec.psk "raspberry"
sudo nmcli con mod hotspot ipv4.gateway 192.168.50.1



#start New Hotspot
sudo nmcli con up hotspot &
sleep 5
systemctl restart isc-dhcp-server.service
