#!/bin/bash

# Handle dpkg prompts non-interactively (keep local changes to configuration files)
export DEBIAN_FRONTEND=noninteractive

# Install Chrome Remote Desktop on the VM instance
echo "Installing Chrome Remote Desktop..."
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo apt-get install --assume-yes ./chrome-remote-desktop_current_amd64.deb

# Set up a Ubuntu desktop environment in the VM instance
echo "Setting up Ubuntu desktop environment..."

# Refresh the repository and package lists, and perform necessary upgrades
# Keeping any local changes to configuration files during the upgrade
sudo -E apt-get update
sudo -E apt-get -o Dpkg::Options::="--force-confold" -y upgrade

# Install and set up SLiM Display Manager
sudo apt-get install -y slim

# Install Ubuntu desktop environment
sudo apt-get install -y ubuntu-desktop

# Restarting the required services without prompts
echo "Restarting services..."
sudo systemctl restart multipathd.service
sudo systemctl restart packagekit.service

# Reboot the machine
echo "Rebooting machine..."
sudo reboot

# Note: 
# After reboot, the user needs to SSH back into the VM and continue with the setup of Chrome Remote Desktop 
# by going to the respective website and following the provided steps there.

# Install Chromium on Ubuntu Desktop
echo "Installing Chromium..."
sudo snap install chromium

echo "All tasks completed."
