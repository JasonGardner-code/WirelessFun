#!/bin/bash

# Set up hostapd configuration
cat <<EOL > /etc/hostapd/hostapd.conf
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
  sleep 5
done
