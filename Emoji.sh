#!/bin/bash

# Function to generate random emoji SSID
generate_emoji_ssid() {
    # Array of emojis with allowable Unicode
    emojis=("🌟" "🔥" "🌈" "🎉" "🐱" "🦄" "🍕" "🚀" "🌺" "🍦" "🎸" "📚" "🎈" "🍩" "🍀" "💡" "🌍" "🌞" "🐾" "🎨")

    # Get random emoji from the array
    random_index=$(( RANDOM % ${#emojis[@]} ))
    echo "${emojis[$random_index]}"
}

# Install hostapd if not already installed
if ! command -v hostapd &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y hostapd
fi

# Configure hostapd
sudo cat <<EOF > /etc/hostapd/hostapd.conf
interface=wlan0
driver=nl80211
ssid=$(generate_emoji_ssid)
hw_mode=g
channel=6
ieee80211n=1
wmm_enabled=1
ht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=password123
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF

# Start hostapd
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl start hostapd

# Continuously send out new SSID every 5 seconds
while true; do
    sudo sed -i "s/^ssid=.*/ssid=$(generate_emoji_ssid)/" /etc/hostapd/hostapd.conf
    sudo systemctl restart hostapd
    sleep 5
done
