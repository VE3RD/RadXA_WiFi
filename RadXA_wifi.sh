#!/bin/bash

declare -A ssid
declare -A psk
declare -i exitcode=2
declare -i indx
declare -A matrix
declare -a pria
num_rows=3
num_columns=2

ssid=()

psk=()
indx=()
pria=()
pri1=""
pri2=""
pri3=""


function Processit(){
var=$1
x=${var:2:1}
indx=$x 

 ssid2=$(awk '/#ssid/{++n; if (n=='$indx') { print ; exit}}' /etc/wpa_supplicant/wpa_supplicant.conf | cut -d "=" -f2 | tr -d '"')
 ssid1=$(echo "$ssid2" | tr -dc '\11\12\15\40-\176\106\108\109' | sed 's/\r//')
 

 psk2=$(awk '/#psk/{++n; if (n=='$indx') { print ; exit}}' /etc/wpa_supplicant/wpa_supplicant.conf | cut -d "=" -f2 | tr -d '"' )
 psk1=$(echo "$psk2"| tr -cd '\11\12\15\40-\176\106\108\109' | sed 's/\r//')


echo -e "Trying to Connect to $ssid1 with Password: $psk1 Priority: $pri Indx:$indx"
        Host=$(ls /etc/NetworkManager/system-connections/ | grep "$ssid1")
	echo "Looking for Host $ssid1"
        if [ -z "$Host" ]; then
                sudo nmcli dev wifi connect "$ssid1" password "$psk1" 
		exitcode=$?
		if [ $exitcode -eq 0 ]; then
			echo -e "Created New Network file for $ssid1\n"
		fi
        else
		echo -e "Found Existing Host $ssid1 - trying to Connect\n"
                sudo nmcli con up "$ssid1" 
		exitcode=$?
        fi

return 
}

#=========================== Main File ==============================
#Block 1
pri2=$(awk '/priority/{++n; if (n==1) { print ; exit}}' /etc/wpa_supplicant/wpa_supplicant.conf | cut -d "=" -f2 )
pri1=$(echo "$pri2" | tr -dc '\11\12\15\40-\176')
pri3=$(echo "$pri1" | sed 's/\r//')
tmp1=$(echo $((($pri3-1)*10+1)) | bc)
pria[0]="$tmp1"
#==========================================
#Block 2
pri2=$(awk '/priority/{++n; if (n==2) { print ; exit}}' /etc/wpa_supplicant/wpa_supplicant.conf | cut -d "=" -f2 )
pri1=$(echo "$pri2" | tr -dc '\11\12\15\40-\176')
if [ "$pri2" ]; then
	pri3=$(echo "$pri1" | sed 's/\r//')
	tmp2=$(echo $((($pri3-1)*10+2)) | bc)
	pria[1]="$tmp2"
fi
#========================================"
#Block 3
pri2=$(awk '/priority/{++n; if (n==3) { print ; exit}}' /etc/wpa_supplicant/wpa_supplicant.conf | cut -d "=" -f2 )
pri1=$(echo "$pri2" | tr -dc '\11\12\15\40-\176')
if [ "$pri2" ]; then
	pri3=$(echo "$pri1" | sed 's/\r//')
	tmp3=$(echo $((($pri3-1)*10+3)) | bc)
	pria[2]="$tmp3"
fi

IFS=$'\n' sorted=($(sort -r <<<"${pria[*]}"))
unset IFS

# Load ssid, psk array
exitcode=2


 Processit ${sorted[0]}

if [ $exitcode -ne 0 ] && [ "$tmp2" ];then
 Processit ${sorted[1]}
fi
if [ $exitcode -ne 0 ] && [ "$tmp3" ]; then
 Processit ${sorted[2]}
fi

if [ $exitcode -ne 0 ]; then
	## Delete all hotspot config files
	sudo rm /etc/NetworkManager/system-connections/hotspot*

	##Restart NetworkManager.service
	systemctl restart NetworkManager.service

	#Create New Hotspot config file
	sudo nmcli con add type wifi ifname wlan0 con-name hotspot autoconnect yes ssid RadXA
	sudo nmcli con modify hotspot 802-11-wireless.mode ap 802-11-wireless.band bg
	sudo nmcli con modify hotspot ipv4.addresses 192.168.50.1/24
	sudo nmcli con mod hotspot ipv4.gateway 192.168.50.1
	sudo nmcli con mod hotspot ipv4.method manual
	sudo nmcli con modify hotspot wifi-sec.key-mgmt wpa-psk
	sudo nmcli con modify hotspot wifi-sec.psk "raspberry"

	##Restart NetworkManager.service
	systemctl restart NetworkManager.service

	#start New Hotspot
	sudo nmcli con up hotspot &
	sleep 4
	sudo systemctl restart isc-dhcp-server.service
fi


