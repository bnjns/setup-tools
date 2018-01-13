#!/bin/bash
if [ -z $DIR_BASE ]; then DIR_BASE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"; fi

ESCAPE="\033"
COLOUR_RESET="$ESCAPE[0m"
COLOUR_TEXT_BLACK="$ESCAPE[30m"
COLOUR_TEXT_RED="$ESCAPE[31m"
COLOUR_TEXT_GREEN="$ESCAPE[32m"
COLOUR_TEXT_YELLOW="$ESCAPE[33m"
COLOUR_TEXT_BLUE="$ESCAPE[34m"
COLOUR_TEXT_MAGENTA="$ESCAPE[35m"
COLOUR_TEXT_CYAN="$ESCAPE[36m"
COLOUR_TEXT_LIGHT_GREY="$ESCAPE[37m"
COLOUR_TEXT_DARK_GREY="$ESCAPE[90m"
COLOUR_TEXT_LIGHT_RED="$ESCAPE[91m"
COLOUR_TEXT_LIGHT_GREEN="$ESCAPE[92m"
COLOUR_TEXT_LIGHT_YELLOW="$ESCAPE[93m"
COLOUR_TEXT_LIGHT_BLUE="$ESCAPE[94m"
COLOUR_TEXT_LIGHT_MAGENTA="$ESCAPE[95m"
COLOUR_TEXT_LIGHT_CYAN="$ESCAPE[96m"
COLOUR_TEXT_WHITE="$ESCAPE[97m"
COLOUR_BG_BLACK="$ESCAPE[40m"
COLOUR_BG_RED="$ESCAPE[41m"
COLOUR_BG_GREEN="$ESCAPE[42m"
COLOUR_BG_YELLOW="$ESCAPE[43m"
COLOUR_BG_BLUE="$ESCAPE[44m"
COLOUR_BG_MAGENTA="$ESCAPE[45m"
COLOUR_BG_CYAN="$ESCAPE[46m"
COLOUR_BG_LIGHT_GREY="$ESCAPE[47m"
COLOUR_BG_DARK_GREY="$ESCAPE[100m"
COLOUR_BG_LIGHT_RED="$ESCAPE[101m"
COLOUR_BG_LIGHT_GREEN="$ESCAPE[102m"
COLOUR_BG_LIGHT_YELLOW="$ESCAPE[103m"
COLOUR_BG_LIGHT_BLUE="$ESCAPE[104m"
COLOUR_BG_LIGHT_MAGENTA="$ESCAPE[105m"
COLOUR_BG_LIGHT_CYAN="$ESCAPE[106m"
COLOUR_BG_WHITE="$ESCAPE[107m"
TEXT_CHECK="\xE2\x9C\x94"
TEXT_CROSS="\xE2\x9C\x96"
LINE_OFFSET=0

function getOS
{
  case "$OSTYPE" in
    solaris*) echo "SOLARIS" ;;
    darwin*)  echo "OSX" ;;
    linux*)   echo "LINUX" ;;
    bsd*)     echo "BSD" ;;
    msys*)    echo "WINDOWS" ;;
    *)        echo "UNKNOWN" ;;
  esac
}

function getLinuxDistribution
{
	local OS=$(getOS)
	if [ $OS = "LINUX" ]; then
		. /etc/lsb-release
		echo $DISTRIB_ID | tr '[:lower:]' '[:upper:]'
	else
		echo ""
	fi
}

function getFullOS
{
	local OS=$(getOS)
	local DISTRIB=$(getLinuxDistribution)
	if  [ -z $DISTRIB ]; then
		echo $OS
	else
		echo $OS"_"$DISTRIB
	fi
}

function inArray
{
	local e match="$1"
	shift
	for e; do [[ "$e" == "$match" ]] && return 0; done
	return 1
}

function getColourString
{
	case "$1" in
	black )
	    echo "$COLOUR_TEXT_BLACK"
	    ;;
    red )
        echo "$COLOUR_TEXT_RED"
        ;;
    green )
        echo "$COLOUR_TEXT_GREEN"
        ;;
    yellow )
        echo "$COLOUR_TEXT_YELLOW"
        ;;
    blue )
        echo "$COLOUR_TEXT_BLUE"
        ;;
    magenta )
        echo "$COLOUR_TEXT_MAGENTA"
        ;;
    cyan )
        echo "$COLOUR_TEXT_CYAN"
        ;;
	reset )
	    echo "$COLOUR_RESET"
	    ;;
	* )
	    echo ""
	    ;;
  esac
}

function start
{
    if [ -z $2 ] || [ $2 -eq 1 ]
    then
        LINE_OFFSET=0
    else
        LINE_OFFSET=$((2*$(($2-1))))
    fi

    echo -e "\033["$LINE_OFFSET"C[ ] $1"
}

function success
{
    echo -e "\033[1A""\r""\033["$LINE_OFFSET"C"$COLOUR_TEXT_GREEN"["$TEXT_CHECK"]"$COLOUR_RESET
}

function error
{
    echo -e "\033[1A""\r""\033["$LINE_OFFSET"C"$COLOUR_TEXT_RED"["$TEXT_CROSS"]"$COLOUR_RESET
}

# Make sure the script is being run as root
if (( UID != 0 )); then exec sudo -E "$0" ${1+"$@"}; fi

# Get the username running the script
if [ $SUDO_USER ]; then USERNAME=$SUDO_USER; else USERNAME=$(whoami); fi

# Get the OS
OS=$(getOS)
DISTRIB=$(getLinuxDistribution)
OS_FULL=$(getFullOS)