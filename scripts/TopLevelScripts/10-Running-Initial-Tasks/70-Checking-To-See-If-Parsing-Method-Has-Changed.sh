#!/bin/bash
## This Checks if parsing method has changed

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

SCRIPTTEXT="Finding The most recently modified Parsing Script File."
printf "$cyan"    "$SCRIPTTEXT"
echo "### $SCRIPTTEXT" | tee --append $RECENTRUN &>/dev/null
YOUNGESTPARSINGFILE=$(echo `ls -t $PARSINGPROCESSSCRIPTSDIR | awk '{printf("%s",$0);exit}'`)
YOUNGESTPARSINGFILEB="$PARSINGPROCESSSCRIPTSDIR""$YOUNGESTPARSINGFILE"
YOUNGFILEMODIFIEDLAST=$(stat -c %z "$YOUNGESTPARSINGFILEB")
YOUNGFILEMODIFIEDTIME=$(date --date="$YOUNGFILEMODIFIEDLAST" +%s)
printf "$yellow"    "The Most Recently Updated Parsing Script is $YOUNGESTPARSINGFILE"
printf "$yellow"  "Young File timestamp is set to $YOUNGFILEMODIFIEDTIME"
echo "* The Most Recently Updated Parsing Script is $YOUNGESTPARSINGFILE" | tee --append $RECENTRUN &>/dev/null

SCRIPTTEXT="Checking For Time Anchor File."
printf "$cyan"    "$SCRIPTTEXT"
echo "### $SCRIPTTEXT" | tee --append $RECENTRUN &>/dev/null
if [[ -f $TIMEANCHORFILE ]]
then
  echo "Time Anchor File Present." | tee --append $RECENTRUN &>/dev/null
  source $TIMEANCHORFILE
else
  echo "Time Anchor Not Present. Using $YOUNGESTPARSINGFILE Modified Time." | tee --append $RECENTRUN &>/dev/null
  printf "$yellow"  "Time Anchor Not Present. Using $YOUNGESTPARSINGFILE Modified Time."
  TIMEANCHORSTAMP=$YOUNGFILEMODIFIEDTIME
fi

printf "$yellow"  "Time Anchor is set to $TIMEANCHORSTAMP"

SCRIPTTEXT="Comparing Time."
printf "$cyan"    "$SCRIPTTEXT"
echo "### $SCRIPTTEXT" | tee --append $RECENTRUN &>/dev/null
if [[ $YOUNGFILEMODIFIEDTIME == $TIMEANCHORSTAMP ]]
then
  printf "$yellow"   "Parsing Method Has Not Changed."
  echo "Parsing Method Has Not Changed." | tee --append $RECENTRUN &>/dev/null
  NOPARSINGCHANGE="true"
elif [[ $YOUNGFILEMODIFIEDTIME != $TIMEANCHORSTAMP ]]
then
  printf "$green"   "Parsing Method Has Changed."
  echo "Parsing Method Has Changed." | tee --append $RECENTRUN &>/dev/null
  EXECUTEORDERSIXTYSIX="true"
fi

if [[ -n $EXECUTEORDERSIXTYSIX && -z $NOPARSINGCHANGE ]]
then
  echo ""
  SCRIPTTEXT="Resetting For a Re-Parse."
  printf "$cyan"    "$SCRIPTTEXT"
  echo "### $SCRIPTTEXT" | tee --append $RECENTRUN &>/dev/null
fi

if [[ -n $EXECUTEORDERSIXTYSIX && -z $NOPARSINGCHANGE ]]
then
  if ls $PARSEDBLACKLISTSSUBALL &> /dev/null;
  then
    echo "* Resetting Parsed Lists For Reprocessing" | tee --append $RECENTRUN &>/dev/null
    printf "$yellow"   "Resetting Parsed Lists For Reprocessing."
    rm $PARSEDBLACKLISTSSUBALL
  fi
fi

if [[ -n $EXECUTEORDERSIXTYSIX && -z $NOPARSINGCHANGE ]]
then
  if ls $BLACKLSTSTHATDIEALL &> /dev/null;
  then
    echo "* Resetting Killed Lists For Reprocessing" | tee --append $RECENTRUN &>/dev/null
    printf "$yellow"   "Resetting Killed Lists For Reprocessing."
    for f in $BLACKLSTSTHATDIEALL
    do
      BASEFILENAME=$(echo `basename $f | cut -f 1 -d '.'`)
      BUNDEADPARSELIST="$MAINBLACKLSTSDIR""$BASEFILENAME".lst
      mv $f $BUNDEADPARSELIST
    done
  fi
fi

if [[ -z $NOPARSINGCHANGE ]]
then
  SCRIPTTEXT="Updating Time Anchor File."
  printf "$cyan"    "$SCRIPTTEXT"
  echo "### $SCRIPTTEXT" | tee --append $RECENTRUN &>/dev/null
fi

if [[ -z $NOPARSINGCHANGE && -f $TIMEANCHORFILE ]]
then
  rm $TIMEANCHORFILE
fi

if [[ ! -f $TIMEANCHORFILE ]]
then
  echo "## This is a time anchor file" | tee --append $TIMEANCHORFILE &>/dev/null
  echo "## This is the Timestamp that the parsing process last changed" | tee --append $TIMEANCHORFILE &>/dev/null
  echo "TIMEANCHORSTAMP="$YOUNGFILEMODIFIEDTIME"" | tee --append $TIMEANCHORFILE &>/dev/null
fi
