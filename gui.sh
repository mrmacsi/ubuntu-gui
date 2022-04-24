#!/bin/sh
ls
sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install lightdm -y
sudo systemctl start lightdm

sudo apt-get install tasksel -y

sudo apt-get install ubuntu-desktop -y
sudo systemctl set-default graphical.target

sudo adduser macit

wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb -P /tmp
sudo apt-get install /tmp/chrome-remote-desktop_current_amd64.deb -y

sudo snap install android-studio --classic
sudo apt-get install qemu-kvm -y
sudo adduser $USER kvm
sudo chown $USER /dev/kvm
sudo chmod 777 -R /dev/kvm

reboot
