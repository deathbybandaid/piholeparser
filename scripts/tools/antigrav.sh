#!/bin/bash
## This should show what lines are not making it through gravity.sh

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

## Pihole vars
PIHOLEDIR=/etc/pihole/
PIHOLEVARSCONF="$PIHOLEDIR"setupVars.conf
PIHOLEGRAVITY="$PIHOLEDIR"gravity.list
PIHOLEGRAVITYSH=/etc/.pihole/gravity.sh
ANTIGRAV="TEMPDIR"antigrav.list.txt

if [[ -f $PIHOLEVARSCONF ]]
then
  source $PIHOLEVARSCONF
else
  echo "$PIHOLEVARSCONF missing"
  exit
fi
TRIMMEDIP=${IPV4_ADDRESS%/*}
CURRENTUSER="$(whoami)"

## whiptail required
if which whiptail >/dev/null;
then
  :
else
  printf "$yellow"  "Installing whiptail"
  apt-get install -y whiptail
fi

## Remove old antigrav
if [[ -f $ANTIGRAV ]]
then
  rm $ANTIGRAV
fi

## Update Gravity
# pihole -g
if (whiptail --title "AntiGrav" --yes-button "No" --no-button "Yes" --yesno "Do you want to run Gravity Now?" 10 80) 
then
  echo "not running gravity"
else
  bash $PIHOLEGRAVITYSH
fi

## Trim IP from HOSTS format
HOSTIP=$(whiptail --inputbox "What IP Needs to be removed?" 10 80 "$TRIMMEDIP" 3>&1 1>&2 2>&3)
sed "s/^$HOSTIP\s\+[ \t]*//" < $PIHOLEGRAVITY > $TEMPFILE

## WhatDiff
gawk 'NR==FNR{a[$0];next} !($0 in a)' $BIGAPLE $TEMPFILE > $FILETEMP
rm $TEMPFILE
cat $FILETEMP | sed 's/\s\+$//; /^$/d; /[[:blank:]]/d' > $ANTIGRAV
rm $FILETEMP
HOWMANYLINES=$(echo -e "`wc -l $ANTIGRAV | cut -d " " -f 1`")
printf "$yellow"  "Antigrav File contains $HOWMANYLINES Domains that are not used by gravity."
