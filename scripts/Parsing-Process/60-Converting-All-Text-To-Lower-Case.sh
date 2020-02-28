#!/bin/bash
## Convert All Text To Lower Case

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

if [[ -f $BFILETEMP ]]
then
  cat $BFILETEMP | sed 's/\([A-Z]\)/\L\1/g' > $BTEMPFILE
fi

if [[ -f $BFILETEMP ]]
then
  rm $BFILETEMP
fi
