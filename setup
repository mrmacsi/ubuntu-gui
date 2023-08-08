#!/bin/bash

# Install Chrome Remote Desktop on the VM instance
echo "Installing Chrome Remote Desktop..."
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo apt-get install --assume-yes ./chrome-remote-desktop_current_amd64.deb

# Set up a Ubuntu desktop environment in the VM instance
echo "Setting up Ubuntu desktop environment..."

# Refresh the repository and package lists, and perform necessary upgrades
sudo apt update && sudo apt upgrade -y

# Install and set up SLiM Display Manager
sudo apt install -y slim

# Install Ubuntu desktop environment
sudo apt install -y ubuntu-desktop

# Reboot the machine
echo "Rebooting machine..."
sudo reboot

# There's a pause here because the machine will reboot
# You'd need to SSH back into the VM and then run the next commands

# Start SLiM
sudo service slim start

# Note: 
# After this, the user would need to go to the Chrome Remote Desktop website,
# set up the VM using the command line provided on the website, and provide the PIN.

# Install an app on your Ubuntu Desktop
echo "Installing Chromium..."
sudo snap install chromium

echo "All tasks completed."
