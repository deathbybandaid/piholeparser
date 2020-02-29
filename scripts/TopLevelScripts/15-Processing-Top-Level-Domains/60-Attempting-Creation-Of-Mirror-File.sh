#!/bin/bash
# shellcheck disable=SC1090,SC2034,SC2154
##

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.sh

if [[ -n $FULLSKIPPARSING ]]
then
  printf "$green"  "Old Mirror File Retained."
fi

## This helps when replacing the mirrored file
if  [[ -z $FULLSKIPPARSING && -z $FILESIZEZERO && -f $CURRENTTLDLIST ]]
then
  printf "$green"  "Old Mirror File Removed"
  rm $CURRENTTLDLIST
fi

if  [[ -z $FULLSKIPPARSING && -z $FILESIZEZERO ]]
then
  printf "$green"  "Creating Mirror Of Unparsed File."
  mv $BTEMPFILE $CURRENTTLDLIST
elif [[ -z $FULLSKIPPARSING && -n $FILESIZEZERO ]]
then
  rm $BTEMPFILE
fi
