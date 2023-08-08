#!/bin/bash

# Handle dpkg prompts non-interactively (keep local changes to configuration files)
export DEBIAN_FRONTEND=noninteractive

# --- Start setup ---

echo ""
echo "------------------------------------"
echo "Starting the setup..."
echo ""

# Refresh the repository and package lists
echo ""
echo "------------------------------------"
echo "Refreshing repository and package lists..."
echo ""
sudo -E apt-get update

# Perform necessary upgrades, keeping local changes to configuration files
echo ""
echo "------------------------------------"
echo "Upgrading packages and keeping local changes to config files..."
echo ""
sudo DEBIAN_FRONTEND=noninteractive UCF_FORCE_CONFFOLD=1 apt-get -o Dpkg::Options::="--force-confold" --assume-yes -y upgrade

# Install SLiM Display Manager
echo ""
echo "------------------------------------"
echo "Installing SLiM Display Manager..."
echo ""
echo "slim" | sudo DEBIAN_FRONTEND=noninteractive apt-get install -y slim

# Install Ubuntu desktop environment
echo ""
echo "------------------------------------"
echo "Installing Ubuntu desktop environment..."
echo ""
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends lubuntu-desktop

# Add user 'macit'
echo ""
echo "------------------------------------"
echo "Adding user 'macit'..."
echo ""
sudo adduser macit --disabled-password --gecos 'Macit,,,,'

# Set password for user 'macit'
echo ""
echo "------------------------------------"
echo "Setting password for user 'macit'..."
echo ""
echo "macit:password" | sudo chpasswd

# Create swap file
echo ""
echo "------------------------------------"
echo "Creating and configuring 2GB swap file..."
echo ""
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Install Chrome Remote Desktop
echo ""
echo "------------------------------------"
echo "Installing Chrome Remote Desktop..."
echo ""
sudo kill -9 $(lsof -t /var/lib/dpkg/lock-frontend)
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y xvfb xserver-xorg-video-dummy xbase-clients python3-packaging python3-psutil python3-xdg libgbm1
sudo DEBIAN_FRONTEND=noninteractive dpkg -i chrome-remote-desktop_current_amd64.deb

# Install Chromium browser
echo ""
echo "------------------------------------"
echo "Installing Chromium browser..."
echo ""
sudo snap install chromium --classic

# Reboot
echo ""
echo "------------------------------------"
echo "Rebooting machine..."
echo ""
sudo reboot
