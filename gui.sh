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

DISPLAY= /opt/google/chrome-remote-desktop/start-host --code="4/0AX4XfWi07qmQgnBSDlzxfQ3jcXxpWQtv0scnXYhwRsgumPkvOsY_12n_HVDMI9D9QW8g7A" --redirect-url="https://remotedesktop.google.com/_/oauthredirect" --name=$(hostname)  --user-name=macit

sudo snap install android-studio --classic
sudo apt-get install qemu-kvm -y
sudo adduser $USER kvm
sudo chown $USER /dev/kvm
sudo chmod 777 -R /dev/kvm

reboot
