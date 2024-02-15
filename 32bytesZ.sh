#!/bin/bash

# Function to add controlled Zalgo text to an emoji for taller effect
add_zalgo_to_emoji() {
    local emoji=$1
    # Zalgo components: a limited selection to manage byte size
    local zalgo_above=("̍" "̎" "̄" "̅" "̿" "̑" "̆" "̐" "͒" "͗" "͑" "̇" "̈" "̊" "͂" "̓" "̈́" "͊" "͋" "͌" "̃" "̂" "̌" "͐" "̀" "́" "̋" "̏" "̒" "̓" "̔" "̽" "̉" "ͣ" "ͤ" "ͥ" "ͦ" "ͧ" "ͨ" "ͩ" "ͪ" "ͫ" "ͬ" "ͭ" "ͮ" "ͯ" "̾" "͛" "͆" "̚")
    local zalgo_below=("̖" "̗" "̘" "̙" "̜" "̝" "̞" "̟" "̠" "̤" "̥" "̦" "̩" "̪" "̫" "̬" "̭" "̮" "̯" "̰" "̱" "̲" "̳" "̹" "̺" "̻" "̼" "ͅ" "͡" "͜" "̸" "̷" "͈" "͉" "͍" "͎" "͓" "͔" "͕" "͖" "͙" "͚" "̣")
    
    # Randomly add a moderate amount of Zalgo to keep under 32 bytes
    local zalgoed_emoji=$emoji
    for i in {1..5}; do
        zalgoed_emoji+="${zalgo_above[$RANDOM % ${#zalgo_above[@]}]}"
        zalgoed_emoji+="${zalgo_below[$RANDOM % ${#zalgo_below[@]}]}"
    done
    
    echo "$zalgoed_emoji"
}

# Function to generate random emoji SSID with controlled Zalgo text
generate_emoji_ssid() {
    emojis=("📡" "🔥" "💾" "🚧" "🍕" "🚀" "😂" "💡" "🌍" "🎨" "🍔" "🎵" "🐼" "📷" "🍉" "🍭") # Limited selection for diversity
    ssid=""
    while true; do
        random_index=$(( RANDOM % ${#emojis[@]} ))
        emoji="${emojis[$random_index]}"
        zalgoed_emoji=$(add_zalgo_to_emoji "$emoji")
        next_ssid="$ssid$zalgoed_emoji"
        # Check byte size instead of character length
        if [ $(echo -n "$next_ssid" | wc -c) -le 32 ]; then
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
        # Replace ssid line in the config file, ensuring it does not exceed 32 bytes
        sudo sed -i "s/^ssid=.*$/ssid=$new_ssid/" $card_conf
    done

    # Reload hostapd for both cards
    sudo hostapd_cli -i wlan0 reload
    sudo hostapd_cli -i wlan1 reload

    # Wait for 1 minute before changing SS
