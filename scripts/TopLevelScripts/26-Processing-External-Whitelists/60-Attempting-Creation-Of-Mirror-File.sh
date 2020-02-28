#!/bin/bash
## 

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

## This helps when replacing the mirrored file
if  [[ -n $ORIGFILESIZENOTZERO && -f $MIRROREDFILE ]]
then
  printf "$green"  "Old Mirror File Removed"
  rm $MIRROREDFILE
fi

## Github has a 100mb limit, and empty files are useless
if  [[ "$ORIGFILESIZEBYTES" -eq 0 ]]
then
  printf "$red"     "Not Creating Mirror File. Nothing To Create!"
elif [[ "$ORIGFILESIZEMB" -ge "$GITHUBLIMITMB" ]]
then
  printf "$red"     "Mirror File Too Large For Github."
  echo "* $BASEFILENAME list was $FETCHFILESIZEMB MB, and too large to mirror on github. $timestamp" | tee --append $RECENTRUN &>/dev/null
elif [[ "$FETCHFILESIZEMB" -lt "$GITHUBLIMITMB" ]]
then
  printf "$green"  "Creating Mirror Of Unparsed File."
  cp $WORIGINALFILETEMP $MIRROREDFILE
fi
