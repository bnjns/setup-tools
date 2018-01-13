#!/bin/bash

source ../config.sh

read -p "Enter your username: " USERNAME
read -s -p "Enter your password: " PASSWORD
echo

OS=$1
case "$OS" in
  ubuntu* )
    source _ubuntu.sh
    ;;
  macos* )
    source _macos.sh
    ;;
  * )
    echo -e "\e[31mERROR: Unknown OS Type '$1'\e[0m"
    exit 1;
    ;;
esac

# TODO: Restore backups
# TODO: Enable sites