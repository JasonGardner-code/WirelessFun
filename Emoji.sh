#!/bin/bash

# Array of emoji names
emojis=("😀" "😀" "😍" "🌈" "🍕" "🎉" "🐱" "🚀" "🌍" "🌺" "🍦" "🎸" "🌟" "🐶" "🎮" "🌞" "🍔" "🌸" "🍩" "🎧" "🌊" "🍓" "🦄" "🐼" "🍨" "🎶" "🌙" "🍟" "🦜" "🍉" "🌴" "🎵" "🌮" "🐠" "🍿" "🌹" "🍪" "🎺" "🌄" "🥳" "🐯" "🚗" "🍦" "🐙" "🌻" "🍭" "🎤" "🌳" "🌌" "🍟" "🦊" "🍇" "🌷" "🍫" "🎼" "🌜" "🥨" "🍌" "🌵" "🎷" "🌃" "🌭" "🦀" "🍪" "🌹" "🍿" "🌰" "🎻" "🌅" "🍦" "🐹" "🚀" "🌈" "🍕" "🎉" "🐱" "🚀" "🌍" "🌺" "🍦" "🎸" "🌟" "🐶" "🎮" "🌞" "🍔" "🌸" "🍩" "🎧" "🌊" "🍓" "🦄" "🐼" "🍨" "🎶" "🌙" "😍" "🍕" "🎉" "🐱" "🚀" "🌍" "🌺" "🍦" "🎸" "🌟" "🐶" "🎮" "🌞" "🍔" "🌸" "🍩" "🎧" "🌊" "🍓" "🦄" "🐼" "🍨" "🎶" "🌙" "🍟" "🦜" "🍉" "🌴" "🎵" "🌮" "🐠" "🍿" "🌹" "🍪" "🎺" "🌄" "🥳" "🐯" "🚗")

# Maximum length of SSID
max_length=32

# Function to display available Wi-Fi networks
function display_wifi_networks() {
  clear
  echo "Scanning for Wi-Fi networks..."
  echo "-------------------------------------"
  iwlist <wifi_card_name> scan | grep ESSID | awk -F'"' '{print $2}'
  echo "-------------------------------------"
}

# Function to truncate SSID to maximum length
function truncate_ssid() {
  ssid=$1
  if [ ${#ssid} -gt $max_length ]; then
    ssid=${ssid:0:$max_length}
  fi
  echo "$ssid"
}

# Function to change displayed emojis every 5 seconds
function change_emojis() {
  counter=0
  while true; do
    display_wifi_networks
    echo "Current Emojis:"
    for ((i=counter; i<counter+5; i++)); do
      index=$((i % ${#emojis[@]}))
      emoji=${emojis[index]}
      ssid=$(truncate_ssid "$emoji")
      echo "$ssid"
    done
    counter=$((counter + 5))
    sleep 5
  done
}

This version of the script includes a wider variety of emojis, excluding rainbows. Save the updated script,
