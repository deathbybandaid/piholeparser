#!/bin/bash
## Duplicate Removal

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

if [[ -f $BFILETEMP ]]
then
  cat -s $BFILETEMP | sort -u | gawk '{if (++dup[$0] == 1) print $0;}' > $BTEMPFILE
fi

if [[ -f $BFILETEMP ]]
then
  rm $BFILETEMP
fi
