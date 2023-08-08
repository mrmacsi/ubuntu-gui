#!/bin/bash

# Handle dpkg prompts non-interactively (keep local changes to configuration files)
export DEBIAN_FRONTEND=noninteractive

# Set up a Ubuntu desktop environment in the VM instance
echo "Setting up Ubuntu desktop environment..."

# Refresh the repository and package lists, and perform necessary upgrades
# Keeping any local changes to configuration files during the upgrade
sudo -E apt-get update
sudo DEBIAN_FRONTEND=noninteractive UCF_FORCE_CONFFOLD=1 apt-get -o Dpkg::Options::="--force-confold" --assume-yes -y upgrade

# Install and set up SLiM Display Manager
echo "slim" | sudo DEBIAN_FRONTEND=noninteractive apt-get install -y slim

# Install Ubuntu desktop environment
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ubuntu-desktop

# Add user 'macit' without asking for password and other details
sudo adduser macit --disabled-password --gecos 'Macit,,,'

# Set a default password for the user 'macit'
echo "macit:password" | sudo chpasswd

# Create a 2GB swap file
sudo fallocate -l 2G /swapfile
# Set the correct permissions for the swap file
sudo chmod 600 /swapfile
# Set up the swap space
sudo mkswap /swapfile
# Activate the swap file
sudo swapon /swapfile
# Backup the current fstab file
sudo cp /etc/fstab /etc/fstab.bak
# Add the swap file to fstab to make it permanent
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Install Chrome Remote Desktop on the VM instance
echo "Installing Chrome Remote Desktop..."
sudo kill -9 $(lsof -t /var/lib/dpkg/lock-frontend)
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y xvfb xserver-xorg-video-dummy xbase-clients python3-packaging python3-psutil python3-xdg libgbm1
sudo DEBIAN_FRONTEND=noninteractive dpkg -i chrome-remote-desktop_current_amd64.deb

# Install Chromium on Ubuntu Desktop
echo "Installing Chromium..."
sudo snap install chromium --classic

# Reboot the machine
echo "Rebooting machine..."
sudo reboot
