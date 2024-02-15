#!/bin/bash

# Function to generate random emoji SSID
generate_emoji_ssid() {
    emojis=("📡" "🔥" "💾" "🚧" "🛜" "🍕" "🚀" "😂" "💭" "🎸" "📚" "🎈" "🍩" "🍕" "💡" "🌍" "🌞" "🥶" "🎨" "🍔" "🚲" "🎵" "🏰" "🐼" "🌄" "🚂" "📷" "🍉" "🍭" "🎳" "🏖" "🚁")
    ssid=""
    while [ ${#ssid} -lt 32 ]; do
        random_index=$(( RANDOM % ${#emojis[@]} ))
        emoji="${emojis[$random_index]}"
        ssid="$ssid$emoji"
        if [ ${#ssid} -ge 32 ]; then
            break
        fi
    done
    echo "$ssid"
}

# Loop to update SSIDs
while true; do
    for card_conf in hostapd_card1.conf hostapd_card2.conf; do
        new_ssid=$(generate_emoji_ssid)
        # Replace ssid line in the config file
        sudo sed -i "s/^ssid=.*$/ssid=$new_ssid/" $card_conf
    done

    # Reload hostapd for both cards
    sudo hostapd_cli -i wlan0 reload
    sudo hostapd_cli -i wlan1 reload

    # Wait for 1 minute before changing SSIDs again
    sleep 60
done
