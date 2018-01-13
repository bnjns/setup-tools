#!/bin/bash
DIR_BASE="$(dirname $(readlink -f $0))/.."
source "$DIR_BASE/config.sh"

read -s -p "Enter your password: " PASSWORD
echo

OS=$(get_os)
case $OS in
	LINUX )
		DISTRIB=$(get_linux_distrib)
		case $DISTRIB in
			ubuntu )
				source _linux_ubuntu.sh
				;;
			* )
				echo -e $COLOUR_TEXT_RED"ERROR: This Linux distribution is currently not supported."$COLOUR_RESET
				exit 1
				;;
		esac
		;;
	OSX )
		source _macos.sh
		;;
	* )
		echo -e $COLOUR_TEXT_RED"ERROR: This operating system is currently not supported."$COLOUR_RESET
		exit 1;
		;;
esac

# Set up .bashrc file
echo "PS1=\"\\h:\\w \\\\$ \"" >> $HOME/.bashrc
echo "alias ll=\"ls -lAGH\"" >> $HOME/.bashrc

# Set SSH key
mkdir -p $HOME/.ssh
ssh-keygen -t rsa -C "email@address.invalid" -f $HOME/.ssh/id_rsa -N ""
ssh-add $HOME/.ssh/id_rsa

# TODO: Restore backups
# TODO: Enable sites