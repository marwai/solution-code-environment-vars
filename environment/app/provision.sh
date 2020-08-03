#!/bin/bash

# Update the sources list
sudo apt-get update -y

# upgrade any packages available
sudo apt-get upgrade -y

# install nginx
sudo apt-get install nginx -y

# configuring nginx proxy
sudo unlink /etc/nginx/sites-enabled/default
cd /etc/nginx/sites-available
sudo touch reverse-proxy.conf
sudo chmod 666 reverse-proxy.conf
echo "server{
  listen 80;
  location / {
      proxy_pass http://192.168.10.100:3000;
  }
}" >> reverse-proxy.conf
sudo ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf
sudo service nginx restart

# install git
sudo apt-get install git -y

# install nodejs
# sudo su
# sudo apt-get install python-software-properties
# sudo su
# curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
# sudo su apt-get install nodejs -y

# install pm2 # changes
# apt-get update -y # changes
# cd /home
# sudo npm install pm2 -g
# apt-get update -y # changes

# setting up the app
# export DB_HOST=mongoddb://192.168.10.150:27017/posts"
# cd /home/ubuntu/app
# sudo su
# npm i --no-bin-link # changes
# pm2 stop app.js
# pm2 start app.js -f


# install nodejs
sudo apt-get install python-software-properties
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install nodejs -y



# App set up
export DB_HOST="mongodb://192.168.10.150:27017/posts"
cd /home/ubuntu/app
sudo su
npm install
node app.js
