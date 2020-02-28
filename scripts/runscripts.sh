#!/bin/bash
## This is the central script that ties the others together

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

## Run Logs
if [[ -f $RUNLOGSCRIPT ]]
then
  bash $RUNLOGSCRIPT
fi

## Logo
if [[ -f $AVATARSCRIPT && $REPOBRANCH == "master" ]]
then
  bash $AVATARSCRIPT
else
  echo "Deathbybandaid Logo Missing."
fi

## Check internet connection
if ping -q -w 5 -c 3 8.8.8.8 > /dev/null;
then
  echo "Internet Connection Success!"
else
  echo "No Internet Connection"
  exit
fi

echo ""
for dir in "$TOPLEVELSCRIPTSDIR"[0-9]*/
do

  timestamp=$(echo `date`)
  LOOPSTART=$(date +"%s")
  TOPLEVELSUBDIRPATH="$dir"
  TOPLEVELSUBDIRBASENAME=$(echo `basename $TOPLEVELSUBDIRPATH | cut -f 1 -d '.'`)
  TOPLEVELSUBDIRNAME=$(echo `basename $TOPLEVELSUBDIRPATH | cut -f 1 -d '.' | sed 's/[0-9]/ /g' | sed 's/[\-]/ /'`)
  TOPLEVELSUBDIRSCRIPT="$TOPLEVELSUBDIRPATH""$TOPLEVELSUBDIRNAME".sh
  TOPLEVELSUBDIRSCRIPTTEXT=$(echo `basename $TOPLEVELSUBDIRPATH | cut -f 1 -d '.' | sed 's/[0-9\-]/ /g'`)
  TOPLEVELSUBDIRSCRIPTREPOLOGTAG="[Details If Any]("$TOPLEVELSCRIPTSLOGSDIRGIT""$TOPLEVELSUBDIRBASENAME".md)"

  printf "$blue"    "$DIVIDERBAR"
  echo ""
  printf "$cyan"   "$TOPLEVELSUBDIRSCRIPTTEXT $timestamp"

  ## Log Section
  echo "## $TOPLEVELSUBDIRSCRIPTTEXT $timestamp" | tee --append $MAINRECENTRUNLOGMD &>/dev/null

  ## Clear Temp Before
  if [[ -f $DELETETEMPFILE ]]
  then
    bash $DELETETEMPFILE
  else
    echo "Error Deleting Temp Files."
    exit
  fi

  if [[ -f $TOPLEVELSUBDIRSCRIPT ]]
  then
    bash $TOPLEVELSUBDIRSCRIPT
  fi

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
  elif
    [[ $DIFFTIMELOOPSEC -lt 60 ]]
  then
    LOOPTIMEDIFF="$DIFFTIMELOOPSEC Seconds."
  fi

  echo "Process Took $LOOPTIMEDIFF" | tee --append $MAINRECENTRUNLOGMD &>/dev/null
  echo "$TOPLEVELSUBDIRSCRIPTREPOLOGTAG" | tee --append $MAINRECENTRUNLOGMD &>/dev/null
  echo "" | tee --append $MAINRECENTRUNLOGMD

  printf "$magenta" "$DIVIDERBAR"
  echo ""

## End Of Loop
done

## Push Changes To Github
if [[ -f $PUSHTOGITHUBSCRIPT ]]
then
  bash $PUSHTOGITHUBSCRIPT
fi
