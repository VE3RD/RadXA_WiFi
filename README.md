This collection of script files is intended to handle the wifi functions in the RadXA Zero P-Star.

Location: /boot

startwifi2.sh : 
Looks for wpa_supplicant file in the /boot/ directory. 
If found it will process it and start the configured wifi, 
and copy the wpa_supplicant file to the /etc/wpa_supplicant directory

Location: /usr/local/sbin/

wifi.sh :
This is a gui application that will present a list of wifi connections for the user to select.
It will then presnt a box to enter a password, and then start the selected wifi

setgw.sh :
Occasionaly switching from AP mode to the home network, the default gateway gateway disappears. 
This should ONLY be run if this occurs. Simptoms are total loss of connectivity to the internet.
This script will check for the default gateway and replace it only if missing.
This script will lock the ip and gateway into the Netmanager configuration file for the home network.

RadXA_wifi.sh :
This is the main wifi configuration script. It will scroll down thru the list of networks in the 
/etc/wpa_supplicant/supplicant.con file, sort the connections by priority and start trying to make a connection
starting at the highest priority. 
If it cannot connect to any wifi in the wpa_supplicant file it will start AP mode

startapmode.sh :
This script will manuall start teh hotspot in AP mode.

Location: /etc

rc.local: 
This is a replacement for the /etc/rc.local file that contains all the triggers to handle the wifi functions

Phil VE3RD

