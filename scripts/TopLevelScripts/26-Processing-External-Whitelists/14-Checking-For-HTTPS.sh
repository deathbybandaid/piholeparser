#!/bin/bash
## This checks for secure connection

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

## Is source not using https
if [[ $source != https* ]]
then
  printf "$red"    "$BASEFILENAME List Does NOT Use https."
else
  printf "$green"    "$BASEFILENAME List Does Use https."
fi
