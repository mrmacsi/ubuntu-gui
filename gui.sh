#!/bin/sh

sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install lightdm -y
sudo dpkg-reconfigure lightdm
sudo systemctl start lightdm

sudo apt-get install tasksel -y

sudo apt-get install ubuntu-desktop -y
sudo systemctl set-default graphical.target

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get install ./google-chrome-stable_current_amd64.deb -y

sudo adduser macit -c 'Macit' --disabled-password --gecos 'Macit,,,'

sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cp /etc/fstab /etc/fstab.bak

reboot
