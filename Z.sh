#!/bin/bash

# Function to add Zalgo text to an emoji
add_zalgo_to_emoji() {
    local emoji=$1
    # Zalgo components: a small selection to keep length under control
    local zalgo_above=("̿" "̽" "͇")
    local zalgo_below=("͘" "͚")
    
    # Add Zalgo text above and below randomly
    local zalgoed_emoji=$emoji
    zalgoed_emoji+="${zalgo_above[$RANDOM % ${#zalgo_above[@]}]}"
    zalgoed_emoji+="${zalgo_below[$RANDOM % ${#zalgo_below[@]}]}"
    
    echo "$zalgoed_emoji"
}

# Function to generate random emoji SSID
generate_emoji_ssid() {
    emojis=("📡" "🔥" "💾" "🚧" "🛜" "🍕" "🚀" "😂" "💭" "🛟" "📚" "📶" "🔄" "🍕" "💡" "🌍" "🌞" "🥶" "🎨" "🍔" "🎰" "🎵" "🏰" "🐼" "🌄" "🏴‍☠️" "📷" "🎯" "🏁" "🎳" "🏖" "🚁")
    ssid=""
    while [ ${#ssid} -lt 32 ]; do
        random_index=$(( RANDOM % ${#emojis[@]} ))
        emoji="${emojis[$random_index]}"
        zalgoed_emoji=$(add_zalgo_to_emoji "$emoji")
        next_ssid="$ssid$zalgoed_emoji"
        # Ensure the SSID doesn't exceed 32 characters
        if [ ${#next_ssid} -le 32 ]; then
            ssid=$next_ssid
        else
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
