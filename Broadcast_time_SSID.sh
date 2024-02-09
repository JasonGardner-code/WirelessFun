#!/bin/bash

# Check if hostapd is installed
if ! command -v hostapd &> /dev/null; then
    echo "hostapd is not installed. Please install it first."
    exit 1
fi

# Set the interface name
interface="wlan0"

# Function to start hostapd with the current time as SSID
start_hostapd() {
    # Set the SSID to the current time
    ssid=$(date '+%H:%M:%S')

    # Stop hostapd if already running
    sudo systemctl stop hostapd

    # Create a backup of the original hostapd configuration file
    sudo cp /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf.bak

    # Configure hostapd with the appropriate interface and SSID
    sudo bash -c "cat > /etc/hostapd/hostapd.conf << EOL
interface=$interface
ssid=$ssid
hw_mode=g
channel=7
auth_algs=1
wpa=2
wpa_passphrase=YourPassphraseHere
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP CCMP
rsn_pairwise=CCMP
EOL"

    # Start hostapd
    sudo systemctl start hostapd

    echo "Hostapd started broadcasting SSID: $ssid"
}

# Start broadcasting every 5 seconds
while true; do
    start_hostapd
    sleep 5
done
