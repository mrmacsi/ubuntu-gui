#!/bin/sh

# Update and upgrade without asking questions
sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -qq

# Install lightdm and start it
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq lightdm
sudo systemctl start lightdm

# Install tasksel
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq tasksel

# Install Ubuntu desktop and set graphical target as default
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq ubuntu-desktop
sudo systemctl set-default graphical.target

# Install Google Chrome
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq ./google-chrome-stable_current_amd64.deb

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

# Reboot the system
sudo reboot
