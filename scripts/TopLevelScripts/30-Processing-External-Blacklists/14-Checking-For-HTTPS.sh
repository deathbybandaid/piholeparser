#!/bin/bash
# shellcheck disable=SC1090,SC2034,SC2154

## This checks for secure connection

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.sh

## Is source not using https
if [[ $source != https* ]]
then
  printf "$red"    "$BASEFILENAME List Does NOT Use https."
else
  printf "$green"    "$BASEFILENAME List Does Use https."
fi
