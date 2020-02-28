#!/bin/bash
## Domain Requirements,, a period and a letter

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

if [[ -f $BFILETEMP ]]
then
  cat $BFILETEMP | sed '/[a-z]/!d; /[.]/!d; /[a-z]$/!d; /^\./d; /\.$/d; /^.\{,255\}$/!d;/^-/ d' > $BTEMPFILE
fi

if [[ -f $BFILETEMP ]]
then
  rm $BFILETEMP
fi
