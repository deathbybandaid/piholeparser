#!/bin/bash
## Check File size

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

if [[ -f $BPARSEDFILETEMP ]]
then
  PARSEDFILESIZEBYTES=$(stat -c%s "$WPARSEDFILETEMP")
  echo "PARSEDFILESIZEBYTES="$PARSEDFILESIZEBYTES"" | tee --append $TEMPPARSEVARS &>/dev/null
  PARSEDFILESIZEKB=`expr $PARSEDFILESIZEBYTES / 1024`
  echo "PARSEDFILESIZEKB="$PARSEDFILESIZEKB"" | tee --append $TEMPPARSEVARS &>/dev/null
  PARSEDFILESIZEMB=`expr $PARSEDFILESIZEBYTES / 1024 / 1024`
  echo "PARSEDFILESIZEMB="$PARSEDFILESIZEMB"" | tee --append $TEMPPARSEVARS &>/dev/null
fi

timestamp=$(echo `date`)

if [[ -n $PARSINGEMPTIEDFILE && "$PARSEDFILESIZEBYTES" -eq 0 ]]
then
  printf "$red"  "Current Parsing Method Emptied File. It will be skipped in the future."
  timestamp=$(echo `date`)
  echo "* $BASEFILENAME List Was Killed By The Parsing Process. It will be skipped in the future. $timestamp" | tee --append $RECENTRUN &>/dev/null
  mv $FILEBEINGPROCESSED $KILLTHELIST
fi

if [[ -f $KILLTHELIST && -f $PARSEDFILE ]]
then
  printf "$red"  "Current Parsing Method Emptied File. Old File Removed."
  rm $PARSEDFILE
fi

if [[ -f $KILLTHELIST && -f $MIRROREDFILE ]]
then
  printf "$red"  "Current Parsing Method Emptied File. Mirror File Removed."
  rm $MIRROREDFILE
fi

if [[ -f $WPARSEDFILETEMP && "$PARSEDFILESIZEBYTES" -eq 0 ]]
then
  rm $WPARSEDFILETEMP
elif [[ -f $WPARSEDFILETEMP && "$PARSEDFILESIZEBYTES" -gt 0 ]]
then
  PARSEDFILESIZENOTZERO=true
  echo "PARSEDFILESIZENOTZERO="$PARSEDFILESIZENOTZERO"" | tee --append $TEMPPARSEVARS &>/dev/null
fi

## File size
if [[ -n $PARSEDFILESIZENOTZERO && "$PARSEDFILESIZEMB" -gt 0 && "$PARSEDFILESIZEKB" -gt 0 && "$PARSEDFILESIZEBYTES" -gt 0 ]]
then
  printf "$yellow"  "Size of $BASEFILENAME = $PARSEDFILESIZEMB MB."
elif [[ -n $PARSEDFILESIZENOTZERO && "$PARSEDFILESIZEMB" -eq 0 && "$PARSEDFILESIZEKB" -gt 0 && "$PARSEDFILESIZEBYTES" -gt 0 ]]
then
  printf "$yellow"  "Size of $BASEFILENAME = $PARSEDFILESIZEKB KB."
elif [[ -n $PARSEDFILESIZENOTZERO && "$PARSEDFILESIZEMB" -eq 0 && "$PARSEDFILESIZEKB" -eq 0 && "$PARSEDFILESIZEBYTES" -gt 0 ]]
then
  printf "$yellow"  "Size of $BASEFILENAME = $PARSEDFILESIZEBYTES Bytes."
fi

## How Many Lines
if [[ -n $PARSEDFILESIZENOTZERO && "$PARSEDFILESIZEBYTES" -gt 0 ]]
then
  PARSEDHOWMANYLINES=$(echo -e "`wc -l $WPARSEDFILETEMP | cut -d " " -f 1`")
  echo "PARSEDHOWMANYLINES="$PARSEDHOWMANYLINES"" | tee --append $TEMPPARSEVARS &>/dev/null
  printf "$yellow"  "$PARSEDHOWMANYLINES Lines After Parsing."
fi
