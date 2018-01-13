#!/bin/bash
source "$(dirname $(readlink -f $0))/../config.sh"

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

# TODO: Restore backups
# TODO: Enable sites