#!/bin/bash
## Checks If Mirror File Is There

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

if [[ -f $MIRROREDFILE ]]
then
  printf "$green"  "Mirror File Currently Available."
else
  printf "$red"  "Mirror File Currently Unavailable."
fi
