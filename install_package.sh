#!/bin/bash

<<note
This script will install any package using arguments
./install_package.sh <arg>
note

echo "This script will install any package using arguments ./install_package.sh <arg>"

echo "*********************** Install $1 *************************"

sudo apt-get update
sudo apt-get install $1 -y

sudo systemctl start $1
sudo systemctl enable $1

echo "*********************** Installed $1 *************************"
