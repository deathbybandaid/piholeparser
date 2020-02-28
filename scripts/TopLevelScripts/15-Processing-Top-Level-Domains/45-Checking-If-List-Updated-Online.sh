#!/bin/bash
##

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

## Check if file is modified since last download
if  [[ -f $CURRENTTLDLIST && -z $PINGTESTFAILED ]]
then
  SOURCEMODIFIEDLAST=$(curl --silent --head $source | awk -F: '/^Last-Modified/ { print $2 }')
  SOURCEMODIFIEDTIME=$(date --date="$SOURCEMODIFIEDLAST" +%s)
  LOCALFILEMODIFIEDLAST=$(stat -c %z "$CURRENTTLDLIST")
  LOCALFILEMODIFIEDTIME=$(date --date="$LOCALFILEMODIFIEDLAST" +%s)
  DIDWECHECKONLINEFILE=true
fi

if [[ -f $CURRENTTLDLIST && -z $PINGTESTFAILED && -n $DIDWECHECKONLINEFILE && $LOCALFILEMODIFIEDTIME -lt $SOURCEMODIFIEDTIME ]]
then
  printf "$yellow"    "File Has Changed Online."
elif [[ -f $CURRENTTLDLIST && -z $PINGTESTFAILED && -n $DIDWECHECKONLINEFILE && $LOCALFILEMODIFIEDTIME -ge $SOURCEMODIFIEDTIME ]]
then
  FULLSKIPPARSING=true
  printf "$green"    "File Not Updated Online. No Need To Process."
  echo "FULLSKIPPARSING="$FULLSKIPPARSING"" | tee --append $TEMPPARSEVARS &>/dev/null
fi
