#!/bin/bash
# shellcheck disable=SC1090,SC2034,SC2154

## Checks for parsed file

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.sh

if [[ -f $PARSEDFILE ]]
then
  printf "$green"  "Parsed File Currently Available."
else
  printf "$red"  "Parsed File Currently Unavailable."
fi
