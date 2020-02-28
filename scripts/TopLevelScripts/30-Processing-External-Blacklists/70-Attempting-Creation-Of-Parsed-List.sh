#!/bin/bash
## 

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

## Delete Parsed file
if [[ ! -f $KILLTHELIST && -f $PARSEDFILE ]]
then
  printf "$green"  "Old Parsed File Removed."
  rm $PARSEDFILE
fi

## Github has a 100mb limit, and empty files are useless
if  [[ "$PARSEDFILESIZEBYTES" -eq 0 ]]
then
  printf "$red"     "Not Creating Parsed File. Nothing To Create!"
elif [[ "$PARSEDFILESIZEMB" -ge "$GITHUBLIMITMB" ]]
then
  printf "$red"     "Parsed File Too Large For Github."
  echo "* $BASEFILENAME list was $PARSEDFILESIZEMB MB, and too large to upload on github. $timestamp" | tee --append $RECENTRUN &>/dev/null
elif [[ "$PARSEDFILESIZEMB" -lt "$GITHUBLIMITMB" && -f $BPARSEDFILETEMP ]]
then
  printf "$green"  "Creating Parsed File."
  cp $BPARSEDFILETEMP $PARSEDFILE
fi
