#!/bin/bash
def=$(route | grep default)

        ip=$(route | grep 255.255.255 | cut -d " " -f1)
        s1=$(echo "$ip" | cut -d "." -f1)
        s2=$(echo "$ip" | cut -d "." -f2)
        s3=$(echo "$ip" | cut -d "." -f3)
        s4=1
        ss="$s1.$s2.$s3.$s4"
	echo "New GW:$ss"

if [ -z "$def" ]; then
        echo "default Route Missing - Adding it"
        route add default gw "$ss" wlan0
        route
else
        echo "Default Route Found - No Action"
fi

echo "Finding Active Connection"

 Con=$(nmcli connection | grep wlan0 | cut -d " " -f1)
echo "Con:$Con   IP:$ip    GW:$ss"
echo  "Active Connection = $Con"



sudo nmcli connection modify "$Con" ipv4.addresses "$ip"/24 ipv4.gateway "$ss"

