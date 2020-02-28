#!/bin/bash
## This should create the fun info for the run log, and Readme.md

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/../foldervars.var

## Start File Loop
## For .sh files In The cleanupscripts Directory

ALLENDTASKSCRIPTS="$COMPLETEFOLDERPATH"/[0-9]*.sh

for f in $ALLENDTASKSCRIPTS
do

  LOOPSTART=$(date +"%s")

  ## Loop Vars
  BASEFILENAME=$(echo `basename $f | cut -f 1 -d '.'`)
  BASEFILENAMENUM=$(echo $BASEFILENAME | sed 's/[0-9]//g')
  BASEFILENAMEDASHNUM=$(echo $BASEFILENAME | sed 's/[0-9\-]/ /g')
  BNAMEPRETTYSCRIPTTEXT=$(echo $BASEFILENAMEDASHNUM)
  TAGTHEREPOLOG="[Details If Any]("$TOPLEVELSCRIPTSLOGSDIRGIT""$SCRIPTBASEFOLDERNAME"/"$BASEFILENAME".md)"
  TAGTHEUPONEREPOLOG="[Go Up One Level]("$TOPLEVELSCRIPTSLOGSDIRGIT""$SCRIPTDIRNAME".md)"

  BREPOLOGDIRECTORY="$TOPLEVELSCRIPTSLOGSDIR""$SCRIPTBASEFOLDERNAME"/
  if [[ ! -d $BREPOLOGDIRECTORY ]]
  then
    mkdir $BREPOLOGDIRECTORY
  fi

  BREPOLOG="$BREPOLOGDIRECTORY""$BASEFILENAME".md

  timestamp=$(echo `date`)

  printf "$lightblue"    "$DIVIDERBARB"
  echo ""

  printf "$cyan"   "$BNAMEPRETTYSCRIPTTEXT $timestamp"
  echo ""

  ## Log Subsection
  echo "## $BNAMEPRETTYSCRIPTTEXT $timestamp" | tee --append $RECENTRUN &>/dev/null

  ## Create Log
  if [[ -f $BREPOLOG ]]
  then
    rm $BREPOLOG
  fi
  echo "$MAINREPOFOLDERGITTAG" | tee --append $BREPOLOG &>/dev/null
  echo "$MAINRECENTRUNLOGMDGITTAG" | tee --append $BREPOLOG &>/dev/null
  echo "$TAGTHEUPONEREPOLOG" | tee --append $BREPOLOG &>/dev/null
  echo "____________________________________" | tee --append $BREPOLOG &>/dev/null
  echo "# $BASEFILENAME" | tee --append $BREPOLOG &>/dev/null

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
  echo "$TAGTHEREPOLOG" | tee --append $RECENTRUN &>/dev/null
  echo "" | tee --append $RECENTRUN

  printf "$orange" "$DIVIDERBARB"
  echo ""

## End Of Loop
done
