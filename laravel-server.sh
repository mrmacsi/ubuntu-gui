#!/bin/sh

sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt install php-mbstring php-xml php-bcmath php-curl
sudo apt install mysql-server
sudo mysql
