#!/bin/bash
## This sets up blacklisting for domains in .lst files

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/../foldervars.var

RECENTRUNBANDAID="$RECENTRUN"

## Quick File Check
timestamp=$(echo `date`)

SCRIPTTEXT="Checking For Script Blacklist File."
printf "$cyan"    "$SCRIPTTEXT"
echo "### $SCRIPTTEXT" | tee --append $RECENTRUN &>/dev/null
if [[ -f $BLACKLISTTEMP ]]
then
  printf "$red"  "Removing Script Blacklist File."
  echo ""
  rm $BLACKLISTTEMP
  touch $BLACKLISTTEMP
  echo "* Blacklist File removed $timestamp" | tee --append $RECENTRUN &>/dev/null
else
  printf "$cyan"  "Script Blacklist File not there. Not Removing."
  echo ""
  touch $BLACKLISTTEMP
  echo "* Script Blacklist File not there, not removing. $timestamp" | tee --append $RECENTRUN &>/dev/null
fi
echo ""

SCRIPTTEXT="Pulling Domains From Individual Lists."
printf "$cyan"    "$SCRIPTTEXT"
echo "### $SCRIPTTEXT" | tee --append $RECENTRUN &>/dev/null


if ls $BLACKDOMAINSALL &> /dev/null;
then

  for f in $BLACKDOMAINSALL
  do

    BASEFILENAME=$(echo `basename $f | cut -f 1 -d '.'`)

    ## Dedupe and Sort
    cat -s $f | sort -u | gawk '{if (++dup[$0] == 1) print $0;}' > $TEMPFILEA
    mv $TEMPFILEA $f

    ## Add to Script.domains
    cat $f >> $BLACKLISTTEMP

    HOWMANYLINES=$(echo -e "`wc -l $f | cut -d " " -f 1`")
    echo "$HOWMANYLINES In $BASEFILENAME" | tee --append $RECENTRUN &>/dev/null
    printf "$yellow"  "$HOWMANYLINES In $BASEFILENAME"

  done

  else
  echo "No Individual Blacklists Present."
  touch $BLACKLISTTEMP
fi

## Total Blacklist
if [[ -f $BLACKLISTTEMP ]]
then
  echo ""
  HOWMANYLINES=$(echo -e "`wc -l $BLACKLISTTEMP | cut -d " " -f 1`")
  echo "$HOWMANYLINES To Blacklist" | tee --append $RECENTRUN &>/dev/null
  printf "$yellow"  "$HOWMANYLINES To Blacklist"
else
  touch $BLACKLISTTEMP
fi

## Dedupe merge
SCRIPTTEXT="Deduplicating Merged List."
printf "$cyan"    "$SCRIPTTEXT"
echo "### $SCRIPTTEXT" | tee --append $RECENTRUN &>/dev/null
if [[ -f $BLACKLISTTEMP ]]
then
  cat -s $BLACKLISTTEMP | sort -u | gawk '{if (++dup[$0] == 1) print $0;}' > $TEMPFILER
  rm $BLACKLISTTEMP
  mv $TEMPFILER $BLACKLISTTEMP
else
  touch $BLACKLISTTEMP
fi
HOWMANYLINES=$(echo -e "`wc -l $BLACKLISTTEMP | cut -d " " -f 1`")
echo "$HOWMANYLINES After $SCRIPTTEXT" | tee --append $RECENTRUN &>/dev/null
printf "$yellow"  "$HOWMANYLINES After $SCRIPTTEXT"
