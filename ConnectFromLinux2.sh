#!/bin/bash

# Path to the text files containing SSID and password lists
ssid_file="/path/to/ssid_list.txt"
password_file="/path/to/password_list.txt"

# Rotation time in seconds
rotation_time=60

# Function to connect to a specific network
connect_to_network() {
  ssid=$1
  password=$2

  # Disconnect from any existing network
  nmcli d disconnect wlan0 >/dev/null 2>&1

  # Connect to the specified network
  if [[ -z "$password" ]]; then
    nmcli d wifi connect "$ssid" >/dev/null 2>&1
  else
    nmcli d wifi connect "$ssid" password "$password" >/dev/null 2>&1
  fi

  # Sleep for a while to allow connection establishment
  sleep 5

  # Check if connection was successful
  if nmcli -t -f GENERAL.STATE dev show wlan0 | grep -q "connected"; then
    echo "Connected to SSID: $ssid"
  else
    echo "Failed to connect to SSID: $ssid"
  fi
}

# Read the SSID and password lists from the files
ssids=()
passwords=()
while IFS= read -r ssid && IFS= read -r password <&3; do
  ssids+=("$ssid")
  passwords+=("$password")
done < "$ssid_file" 3< "$password_file"

# Loop through the SSIDs indefinitely
while true; do
  for ((i=0; i<${#ssids[@]}; i++)); do
    ssid="${ssids[i]}"
    password="${passwords[i]}"

    connect_to_network "$ssid" "$password"

    # Sleep for the rotation time
    sleep "$rotation_time"
  done
done
