#!/bin/bash

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Use 'sudo ./script.sh'" 
   exit 1
fi

# Set up hostapd configuration in a temporary file
temp_conf="/tmp/hostapd_temp.conf"
cat <<EOL > $temp_conf
interface=wlan0
ssid=🔒WiFi1🔒
hw_mode=g
channel=7
wpa=2
wpa_passphrase=password
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOL

# Start hostapd using the temporary configuration file
hostapd $temp_conf &

# Function to generate random emoji SSID
generate_random_emoji_ssid() {
  emojis=("📶WiFi2📶" "🔵WiFi3🔵" "🌐WiFi4🌐" "🚀WiFi5🚀")
  echo ${emojis[$((RANDOM % ${#emojis[@]}))]}
}

# Loop to change SSID every 5 seconds
while true; do
  new_ssid=$(generate_random_emoji_ssid)
  sed -i "s/^ssid=.*/ssid=$new_ssid/" $temp_conf
  sleep 5
done
