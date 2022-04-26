#!/bin/sh
ls

sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install lightdm -y
sudo systemctl start lightdm

sudo apt-get install tasksel -y

sudo apt-get install ubuntu-desktop -y
sudo systemctl set-default graphical.target

wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb -P /tmp
sudo apt-get install /tmp/chrome-remote-desktop_current_amd64.deb -y

sudo adduser macit
