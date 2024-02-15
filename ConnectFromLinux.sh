#!/bin/bash

# Path to the text file containing SSID list
ssid_file="/path/to/ssid_list.txt"

# Rotation time in seconds
rotation_time=60

# Function to connect to a specific network
connect_to_network() {
  ssid=$1
  password=$2

  # Disconnect from any existing network
  nmcli d disconnect wlan0 >/dev/null 2>&1

  # Connect to the specified network
  nmcli d wifi connect "$ssid" password "$password" >/dev/null 2>&1

  # Sleep for a while to allow connection establishment
  sleep 5

  # Check if connection was successful
  if nmcli -t -f GENERAL.STATE dev show wlan0 | grep -q "connected"; then
    echo "Connected to SSID: $ssid"
  else
    echo "Failed to connect to SSID: $ssid"
  fi
}

# Read the SSID list from the file
ssids=()
while IFS= read -r ssid; do
  ssids+=("$ssid")
done < "$ssid_file"

# Loop through the SSIDs indefinitely
while true; do
  for ssid in "${ssids[@]}"; do
    # Get the password for the current SSID (if required)
    password="" # replace with your logic to fetch the password

    connect_to_network "$ssid" "$password"

    # Sleep for the rotation time
    sleep "$rotation_time"
  done
done
