#!/bin/bash

source config.sh

read -p "Enter your username: " USERNAME
read -s -p "Enter your password: " PASSWORD
echo

OS=$1
case "$OS" in
  ubuntu* )
    source os_setup/ubuntu.sh
    ;;
  macos* )
    source os_setup/macos.sh
    ;;
  * )
    echo -e "\e[31mERROR: Unknown OS Type '$1'\e[0m"
    exit 1;
    ;;
esac

# TODO: Restore backups
# TODO: Enable sites