#!/bin/bash
# shellcheck disable=SC1090
## Empty Space

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.sh


if [[ -f $BFILETEMP ]]
then
  cat $BFILETEMP | sed 's/^\s\+[ \t]//g; s/\s\+[ \t]$//g; /^\s*$/d; / /d' > $BTEMPFILE
fi

if [[ -f $BFILETEMP ]]
then
  rm $BFILETEMP
fi
