#!/bin/bash
##

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

if [[ -f $CURRENTTLDLIST ]]
then
  printf "$green"  "Mirror File Currently Available."
else
  printf "$red"  "Mirror File Currently Unavailable."
fi
