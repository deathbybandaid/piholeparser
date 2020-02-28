#!/bin/bash
## Check File size

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

## set filesizezero variable if empty
if [[ -f $BORIGINALFILETEMP ]]
then
  ORIGFILESIZEBYTES=$(stat -c%s "$BORIGINALFILETEMP")
  echo "ORIGFILESIZEBYTES="$ORIGFILESIZEBYTES"" | tee --append $TEMPPARSEVARS &>/dev/null
  ORIGFILESIZEKB=`expr $ORIGFILESIZEBYTES / 1024`
  echo "ORIGFILESIZEKB="$ORIGFILESIZEKB"" | tee --append $TEMPPARSEVARS &>/dev/null
  ORIGFILESIZEMB=`expr $ORIGFILESIZEBYTES / 1024 / 1024`
  echo "ORIGFILESIZEMB="$ORIGFILESIZEMB"" | tee --append $TEMPPARSEVARS &>/dev/null
fi

timestamp=$(echo `date`)

if [[ "$ORIGFILESIZEBYTES" -eq 0 ]]
then
  printf "$red"     "$BASEFILENAME List Was An Empty File After Download."
  timestamp=$(echo `date`)
  echo "* $BASEFILENAME List Was An Empty File After Download. $timestamp" | tee --append $RECENTRUN &>/dev/null
  rm $BORIGINALFILETEMP
elif [[ "$ORIGFILESIZEBYTES" -gt 0 ]]
then
  ORIGFILESIZENOTZERO=true
  echo "ORIGFILESIZENOTZERO="$ORIGFILESIZENOTZERO"" | tee --append $TEMPPARSEVARS &>/dev/null
fi

if [[ "$ORIGFILESIZEBYTES" -eq 0 && $FILEBEINGPROCESSED != $BDEADPARSELIST ]]
then
  printf "$red"  "List Marked As Dead."
  mv $FILEBEINGPROCESSED $BDEADPARSELIST
fi

## File size
if [[ -n $ORIGFILESIZENOTZERO && "$ORIGFILESIZEMB" -gt 0 && "$ORIGFILESIZEKB" -gt 0 && "$ORIGFILESIZEBYTES" -gt 0 ]]
then
  printf "$yellow"  "Size of $BASEFILENAME = $ORIGFILESIZEMB MB."
elif [[ -n $ORIGFILESIZENOTZERO && "$ORIGFILESIZEMB" -eq 0 && "$ORIGFILESIZEKB" -gt 0 && "$ORIGFILESIZEBYTES" -gt 0 ]]
then
  printf "$yellow"  "Size of $BASEFILENAME = $ORIGFILESIZEKB KB."
elif [[ -n $ORIGFILESIZENOTZERO && "$ORIGFILESIZEMB" -eq 0 && "$ORIGFILESIZEKB" -eq 0 && "$ORIGFILESIZEBYTES" -gt 0 ]]
then
  printf "$yellow"  "Size of $BASEFILENAME = $ORIGFILESIZEBYTES Bytes."
fi

## How Many Lines
## Now helps calculate average at the end
if [[ -n $ORIGFILESIZENOTZERO && "$ORIGFILESIZEBYTES" -gt 0 ]]
then
  ORIGHOWMANYLINES=$(echo -e "`wc -l $BORIGINALFILETEMP | cut -d " " -f 1`")
  echo "ORIGHOWMANYLINES="$ORIGHOWMANYLINES"" | tee --append $TEMPPARSEVARS &>/dev/null
  echo "$ORIGHOWMANYLINES" | tee --append $PARSEAVERAGEFILELINES &>/dev/null
  printf "$yellow"  "$ORIGHOWMANYLINES Lines After Download."
fi
