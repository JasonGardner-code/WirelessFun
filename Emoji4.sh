#!/bin/bash

# Array of cyberpunk-themed SSIDs
ssidList=("🌆🦾💻🌃🤖👁️‍🗨️🏙️" "🏢🌆🌉💾💥💥🔥🏙️" "🌌🌃🌆🕹️🧠🌉🌌" "🏙️🌆💡💾🚧👥🔁" "🌃🕵️‍♀️🔍🌆🌉🌆👥🌃" "🌆🔒💻🌌🚀🌌🔒🌆" "🌃🏙️💻💾🌉🔒🔓🚪" "🕶️🌆🚁🌉🏙️📶📶📶" "🌆🌌🌉👤💻🔒🌃🔓" "🏙️🔒🤖💾🌃🔍🔓")

# Function to configure hostapd with the selected SSID
configureHostapd() {
    cat >/etc/hostapd/hostapd.conf <<EOL
interface=wlan0
driver=nl80211
ssid="${ssidList[$1]}"
hw_mode=g
channel=7
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
EOL

    systemctl restart hostapd
}

# Function to display 5 new SSIDs every 5 seconds
displaySSIDs() {
    count=0
    interval=5

    while [ $count -lt 5 ]; do
        randomIndex=$(( RANDOM % 10 ))
        echo "SSID: ${ssidList[$randomIndex]}"
        configureHostapd $randomIndex
        count=$(( count + 1 ))
        sleep $interval
    done
}

# Call the function to display SSIDs and configure hostapd
displaySSIDs
