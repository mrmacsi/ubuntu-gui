#!/bin/sh

sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y php-mbstring php-xml php-bcmath php-curl
sudo apt-get install -y mysql-server
sudo systemctl start mysql.service
sudo mysql
