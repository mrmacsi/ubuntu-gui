#!/bin/bash

# Set the path to your configuration file
config_file="/root/openvpn/openvpn.ovpn"

# Get the config name without the .ovpn extension
config_name=$(basename "$config_file" .ovpn)

echo "Using config file: $config_file"
echo "Config name: $config_name"

openvpn_pid=$(/usr/bin/pgrep openvpn)
echo "Open VPN ID $openvpn_pid"

# Connect to the VPN with the specified config file
echo "Connecting to VPN with config: $config_name"
sudo /usr/sbin/openvpn --config "$config_file" --daemon --log /tmp/openvpn.log --verb 3

# Wait for a few seconds to allow the log file to be populated
sleep 5

# Check the IP address displayed in the log file
new_ip=$(curl -s https://ipinfo.io/ip)
echo "New IP address: $new_ip"

echo "Script completed."
