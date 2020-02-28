#!/bin/bash
## Content Filtering and IP addresses

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

if [[ -f $BFILETEMP ]]
then
  cat $BFILETEMP | sed '/^https\:\/\//d; /^http\:\/\//d; s/[\^]third-party$//g; s/[\^]popup$//g; s/[\^]important$//g; s/[\^]subdocument$//g; s/[\^]websocket$//g; s/^||//; s/[\^]$//g' > $BTEMPFILE
fi

if [[ -f $BFILETEMP ]]
then
  rm $BFILETEMP
fi
