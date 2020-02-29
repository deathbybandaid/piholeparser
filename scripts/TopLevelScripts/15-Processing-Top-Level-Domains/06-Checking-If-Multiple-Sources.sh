#!/bin/bash
# shellcheck disable=SC1090,SC2034,SC2154
##

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.sh

## Amount of sources greater than one?
HOWMANYLINES=$(echo -e "`wc -l $FILEBEINGPROCESSED | cut -d " " -f 1`")
if [[ "$HOWMANYLINES" -gt 1 ]]
then
  printf "$yellow"    "$BASEFILENAME Has $HOWMANYLINES Sources."
fi
