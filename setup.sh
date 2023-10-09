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

# Install Ubuntu desktop environment
echo ""
echo "------------------------------------"
echo "Installing Ubuntu desktop environment..."
echo ""
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ubuntu-desktop

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

# Install Mouse moving tool
echo ""
echo "------------------------------------"
echo "Installing Mouse Moving Tool..."
echo ""
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y xdotool
wget https://raw.githubusercontent.com/mrmacsi/ubuntu-gui/main/move_limited.sh -P /home/macit/
chmod +x /home/macit/move_limited.sh

wget https://raw.githubusercontent.com/mrmacsi/ubuntu-gui/main/open_teams.sh -P /home/macit/
chown macit:macit /home/macit/open_teams.sh
chmod u+rw /home/macit/open_teams.sh
chmod +x /home/macit/open_teams.sh

wget https://raw.githubusercontent.com/mrmacsi/ubuntu-gui/main/close_teams.sh -P /home/macit/
chown macit:macit /home/macit/close_teams.sh
chmod u+rw /home/macit/close_teams.sh
chmod +x /home/macit/close_teams.sh

# Check if .xprofile exists, if not create one
if [ ! -f /home/macit/.xprofile ]; then
    touch /home/macit/.xprofile
fi

# Add the xhost command to .xprofile
echo "xhost +local:" >> /home/macit/.xprofile

# Make sure the .xprofile is executable
chmod +x /home/macit/.xprofile

USER_HOME="/home/macit"

# Create the autostart directory
mkdir -p "$USER_HOME/.config/autostart"

# Navigate to the autostart directory
cd "$USER_HOME/.config/autostart"

# Create the .desktop file with the required content
cat > xhost-local.desktop <<EOF
[Desktop Entry]
Type=Application
Name=XhostLocal
Exec=xhost +local:
Terminal=false
StartupNotify=false
EOF

# Ensure correct permissions
chown -R macit:macit "$USER_HOME/.config/autostart"
chmod +x "$USER_HOME/.config/autostart/xhost-local.desktop"

logfile="/home/macit/cron_output.txt"

if [ ! -f "$logfile" ]; then
    touch "$logfile"
fi

# Save current crontab to a temporary file
crontab -l > mycron

# Append new cron job to the temporary file
echo "* 8-16 * * * /home/macit/move_limited.sh >> /home/macit/cron_output.txt 2>&1" >> mycron

# Install the updated cron jobs
crontab mycron

# Remove the temporary file
rm mycron

crontab -l -u macit > /tmp/macit_crontab

# Install Screenshot
echo ""
echo "------------------------------------"
echo "Installing Screenshot..."
echo ""
sudo apt-get install -y imagemagick

# Append the new cron jobs to the temporary file
echo "0 8 * * * /home/macit/open_teams.sh >> /home/macit/cron_browser_output.txt 2>&1" >> /tmp/macit_crontab
echo "0 16 * * * /home/macit/close_teams.sh >> /home/macit/cron_browser_output.txt 2>&1" >> /tmp/macit_crontab

# Load the updated crontab file for user macit
crontab -u macit /tmp/macit_crontab

# Remove the temporary crontab file
rm /tmp/macit_crontab

# Install Chromium browser
echo ""
echo "------------------------------------"
echo "Installing Chromium browser..."
echo ""
sudo chown macit:macit /home/macit/.config
sudo chmod 755 /home/macit/.config
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get update
sudo apt-get install -f
sudo dpkg -i google-chrome-stable_current_amd64.deb

# Reboot
echo ""
echo "------------------------------------"
echo "Rebooting machine..."
echo ""
sudo reboot
