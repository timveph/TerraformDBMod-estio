#!/bin/bash 
sudo apt update
git clone https://github.com/nathanforester/FlaskMovieDB2.git
touch /home/ubuntu/username /home/ubuntu/password /home/ubuntu/endpoint /home/ubuntu/name
echo ${var.username} > /home/ubuntu/username
echo ${var.password} > /home/ubuntu/password
echo ${var.get_db_endpoint} > /home/ubuntu/endpoint
echo ${var.db_name} > /home/ubuntu/name
export USERNAME=$(cat /home/ubuntu/username) PASSWORD=$(cat /home/ubuntu/password) DB_ENDPOINT=$(cat /home/ubuntu/endpoint) DB_NAME=$(cat /home/ubuntu/name)
sudo apt install mysql-server -y
. /home/ubuntu/FlaskMovieDB2/startup.sh