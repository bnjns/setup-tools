#!/usr/bin/env bash

sudo apt update
sudo apt install ubuntu-budgie-desktop
sudo snap install ubuntu-budgie-welcome --classic

sudo add-apt-repository ppa:papirus/papirus
sudo apt-get update
sudo apt-get install papirus-icon-theme

sudo apt-get install breeze-cursor-theme
