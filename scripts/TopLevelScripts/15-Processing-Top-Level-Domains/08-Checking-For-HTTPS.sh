#!/bin/bash
# shellcheck disable=SC1090,SC2034,SC2154
##

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.sh

if [[ -f $CURRENTTLDLIST ]]
then
  printf "$green"  "Mirror File Currently Available."
else
  printf "$red"  "Mirror File Currently Unavailable."
fi
