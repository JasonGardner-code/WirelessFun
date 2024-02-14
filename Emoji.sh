#!/bin/bash

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Use 'sudo ./script.sh'" 
   exit 1
fi

# Set up initial hostapd configuration
initial_ssid="🔒WiFi1🔒"
cat <<EOL > /etc/hostapd/hostapd.conf
interface=wlan0
ssid=$initial_ssid
hw_mode=g
channel=7
wpa=2
wpa_passphrase=password
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOL

# Start hostapd
hostapd /etc/hostapd/hostapd.conf &

# Function to generate random emoji SSID
generate_random_emoji_ssid() {
  emojis=("📶WiFi2📶" "🔵WiFi3🔵" "🌐WiFi4🌐" "🚀WiFi5🚀")
  echo ${emojis[$((RANDOM % ${#emojis[@]}))]}
}

# Loop to change SSID every 5 seconds
while true; do
  new_ssid=$(generate_random_emoji_ssid)
  sed -i "s/^ssid=.*/ssid=$new_ssid/" /etc/hostapd/hostapd.conf
  systemctl restart hostapd  # Restart hostapd to apply changes
  sleep 5
done
