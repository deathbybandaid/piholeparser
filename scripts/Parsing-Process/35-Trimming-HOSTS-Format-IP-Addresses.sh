#!/bin/bash
## Content Filtering and IP addresses

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

if [[ -f $BFILETEMP ]]
then
  cat $BFILETEMP | sed 's/^PRIMARY\s\+[ \t]*//g; s/^localhost\s\+[ \t]*//g; s/blockeddomain.hosts\s\+[ \t]*//g; s/^0.0.0.0\s\+[ \t]*//g; s/^127.0.0.1\s\+[ \t]*//g; s/^::1\s\+[ \t]*//g' > $BTEMPFILE
fi

if [[ -f $BFILETEMP ]]
then
  rm $BFILETEMP
fi
