#!/bin/bash
## This should do some initial housekeeping for the script

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/../foldervars.var

INITIALTASKSSCRIPTSALL="$COMPLETEFOLDERPATH"/[0-9]*.sh

## Start File Loop
for f in $INITIALTASKSSCRIPTSALL
do

  timestamp=$(echo `date`)
  LOOPSTART=$(date +"%s")

  INITIALTASK="$f"
  INITIALTASKBASENAME=$(echo `basename $INITIALTASK | cut -f 1 -d '.'`)
  INITIALTASKNAME=$(echo `basename $INITIALTASK | cut -f 1 -d '.' | sed 's/[0-9]/ /g' | sed 's/[\-]/ /'`)
  INITIALTASKSCRIPTTEXT=$(echo $INITIALTASKNAME | sed 's/[0-9\-]/ /g')
  INITIALTASKSREPOLOG="[Details If Any]("$TOPLEVELSCRIPTSLOGSDIRGIT""$SCRIPTBASEFOLDERNAME"/"$INITIALTASKBASENAME".md)"

  printf "$lightblue"    "$DIVIDERBARB"
  echo ""

  printf "$cyan"   "$INITIALTASKSCRIPTTEXT $timestamp"
  echo ""

  ## Log Subsection
  echo "## $INITIALTASKSCRIPTTEXT $timestamp" | tee --append $RECENTRUN &>/dev/null

  ## Clear Temp Before
  if [[ -f $DELETETEMPFILE ]]
  then
    bash $DELETETEMPFILE
  else
    echo "Error Deleting Temp Files."
    exit
  fi

  ## Run Script
  bash $f

  ## Clear Temp After
  if [[ -f $DELETETEMPFILE ]]
  then
    bash $DELETETEMPFILE
  else
    echo "Error Deleting Temp Files."
    exit
  fi

  LOOPEND=$(date +"%s")
  DIFFTIMELOOPSEC=`expr $LOOPEND - $LOOPSTART`
  if [[ $DIFFTIMELOOPSEC -ge 60 ]]
  then
    DIFFTIMELOOPMIN=`expr $DIFFTIMELOOPSEC / 60`
    LOOPTIMEDIFF="$DIFFTIMELOOPMIN Minutes."
  elif [[ $DIFFTIMELOOPSEC -lt 60 ]]
  then
    LOOPTIMEDIFF="$DIFFTIMELOOPSEC Seconds."
  fi

  echo "Process Took $LOOPTIMEDIFF" | tee --append $RECENTRUN &>/dev/null
  echo "$INITIALTASKSREPOLOG" | tee --append $RECENTRUN &>/dev/null
  echo "" | tee --append $RECENTRUN

  printf "$orange" "$DIVIDERBARB"
  echo ""

## End Of Loop
done
