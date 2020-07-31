#!/bin/bash

# Update the sources list
sudo apt-get update -y

# upgrade any packages available
sudo apt-get upgrade -y

# install nginx
sudo apt-get install nginx -y

# install git
sudo apt-get install git -y

# install nodejs
sudo su
sudo apt-get install python-software-properties
sudo su
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo su
cd
apt-get install nodejs -y

# install pm2
sudo npm install

# setting up the app
export DB_HOST="mongodb://192.168.10.150:27017/posts"
cd /home/ubuntu/app
sudo su
node app.js
