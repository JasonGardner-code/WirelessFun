```bash
#!/bin/bash

# Array of emoji names
emojis=("😀" "😍" "🌈" "🍕" "🎉" "🐱" "🚀" "🌍" "🌺" "🍦" "🎸" "🌟" "🐶" "🎮" "🌞" "🍔" "🌸" "🍩" "🎧" "🌊" "🍓" "🦄" "🐼" "🍨" "🎶" "🌙" "🍟" "🦜" "🍉" "🌴" "🎵" "🌮" "🐠" "🍿" "🌹" "🍪" "🎺" "🌄" "🥳" "🐯" "🚗")

# Maximum length of SSID
max_length=32

# Function to truncate SSID to maximum length
function truncate_ssid() {
  ssid=$1
  if [ ${#ssid} -gt $max_length ]; then
    ssid=${ssid:0:$max_length}
  fi
  echo "$ssid"
}

# Function to create Wi-Fi access points with emojis as SSIDs using hostapd
function create_wifi_networks() {
  counter=0
  while true; do
    emoji=${emojis[counter % ${#emojis[@]}]}
    ssid=$(truncate_ssid "$emoji")
    config_file="/etc/hostapd/hostapd.conf"
    echo "interface=wlan0" > "$config_file"
    echo "driver=nl80211" >> "$config_file"
    echo "ssid=$ssid" >> "$config_file"
    echo "hw_mode=g" >> "$config_file"
    echo "channel=6" >> "$config_file"
    echo "wpa=2" >> "$config_file"
    echo "wpa_passphrase=Password" >> "$config_file"
    hostapd "$config_file" &
    show_notification "$emoji"
    sleep 5
    counter=$((counter + 1))
  done
}

# Function to display notification with emoji
function show_notification() {
  emoji=$1

  
