#!/bin/bash

# Configuration parameters
interface="wlan0"
ssid_prefix="MyPi-"
emojis=("😀" "😎" "🤖" "🚀" "🔧" "📡" "🌐" "🔍" "🎉")

# Function to update SSID
update_ssid() {
    local count=$1
    local emoji_index=$((count % ${#emojis[@]}))
    local new_ssid="$ssid_prefix${emojis[$emoji_index]}-$count"
    
    # Command to update the SSID using hostapd_cli
    sudo hostapd_cli set config_ssid "$new_ssid"
}

# Function to configure hostapd
configure_hostapd() {
    sudo systemctl stop hostapd
    sudo systemctl stop dhcpcd

    # Add any additional hostapd configuration options here if needed
    sudo hostapd -B /etc/hostapd/hostapd.conf

    sudo systemctl start hostapd
    sudo systemctl start dhcpcd
}

# Main loop counting down from 100
count=100
while [ $count -ge 0 ]; do
    update_ssid "$count"
    sleep 2
    ((count--))
done
