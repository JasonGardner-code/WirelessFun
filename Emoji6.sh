#!/bin/bash

emojis=("😀" "😎" "🤖" "🚀" "🔧" "📡" "🌐" "🔍" "🎉")

update_ssid() {
    local emoji=$1
    local new_ssid="$emoji"

    # Command to update the SSID using hostapd_cli
    sudo hostapd_cli set config_ssid "$new_ssid"
}

# Update SSID with each emoji every second
while true; do
    for emoji in "${emojis[@]}"; do
        update_ssid "$emoji"
        sleep 1
    done
done
