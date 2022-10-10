#!/bin/bash 

sudo apt update
sudo apt-get install python3-venv -y
sudo apt-get install mysql-server -y

python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt


