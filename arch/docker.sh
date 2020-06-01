#!/usr/bin/env bash

sudo pacman -Syu
sudo pacman -S docker

sudo groupadd docker
sudo usermod -aG docker $USER

sudo systemctl enable docker
sudo systemctl start docker

sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose