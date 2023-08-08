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

# Add user 'macit' without asking for password and other details
sudo adduser macit -c 'Macit' --disabled-password --gecos 'Macit,,,'

# Install Chrome Remote Desktop
wget -q https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo DEBIAN_FRONTEND=noninteractive apt install -y -qq ./chrome-remote-desktop_current_amd64.deb

# Create a swap file
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cp /etc/fstab /etc/fstab.bak

# Install Chromium on Ubuntu Desktop
echo "Installing Chromium..."
sudo snap install chromium

# Reboot the machine
echo "Rebooting machine..."
sudo reboot
