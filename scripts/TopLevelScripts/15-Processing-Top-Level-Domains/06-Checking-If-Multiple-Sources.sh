#!/bin/bash
##

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

## Amount of sources greater than one?
HOWMANYLINES=$(echo -e "`wc -l $FILEBEINGPROCESSED | cut -d " " -f 1`")
if [[ "$HOWMANYLINES" -gt 1 ]]
then
  printf "$yellow"    "$BASEFILENAME Has $HOWMANYLINES Sources."
fi
