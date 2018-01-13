#!/bin/bash
DIR_BASE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."
source "$DIR_BASE/config.sh"

echo -ne $COLOUR_TEXT_YELLOW"Enter your password: "$COLOUR_RESET
read -s PASSWORD
echo

case $OS in
	LINUX )
		case $DISTRIB in
			UBUNTU )
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