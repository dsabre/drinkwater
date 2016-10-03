#!/bin/bash

# get current dir
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT_NAME=$(basename "$0")

# check for installation
getopts i INSTALL
if [ $INSTALL == "i" ]; then
	# check if already installed
	if [ $(crontab -l |grep $SCRIPT_NAME |wc -l) -gt 0 ]; then
		echo "Drink water is already installed."
		exit 1
	fi
	
	# add line to crontab
	line="# DRINKWATER\n*/30 9-18 * * 1-5 "$DIR/$SCRIPT_NAME""
	(crontab -l; echo -e "$line" ) | crontab -
	
	echo "Drink water successfully set in crontab."
	exit 0
fi

# transform all lines in config.ini in variables
IFS="="
while read -r name value
do
	declare "$name=$value"
done < "$DIR/config.ini"

# send notify
notify-send -i $DIR/icon.png $title $text

exit $?
