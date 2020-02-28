#!/bin/bash
## Checks for parsed file

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

if [[ -f $PARSEDFILE ]]
then
  printf "$green"  "Parsed File Currently Available."
else
  printf "$red"  "Parsed File Currently Unavailable."
fi
