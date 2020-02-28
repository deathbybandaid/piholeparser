#!/bin/bash
## This sets up whitelisting for domains in .lst files

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/../foldervars.var

RECENTRUNBANDAID="$RECENTRUN"

## Quick File Check
timestamp=$(echo `date`)

SCRIPTTEXT="Checking For Script Whitelist File."
printf "$cyan"    "$SCRIPTTEXT"
echo "### $SCRIPTTEXT" | sudo tee --append $RECENTRUN &>/dev/null
if [[ -f $WHITELISTTEMP ]]
then
  printf "$red"  "Removing Script Whitelist File."
  echo ""
  rm $WHITELISTTEMP
  touch $WHITELISTTEMP
  echo "* Whitelist File removed $timestamp" | tee --append $RECENTRUN &>/dev/null
else
  printf "$cyan"  "Script Whitelist File not there. Not Removing."
  echo ""
  touch $WHITELISTTEMP
  echo "* Script Whitelist File not there, not removing. $timestamp" | tee --append $RECENTRUN &>/dev/null
fi
echo ""

SCRIPTTEXT="Pulling Domains From Individual Lists."
printf "$cyan"    "$SCRIPTTEXT"
echo "### $SCRIPTTEXT" | sudo tee --append $RECENTRUN &>/dev/null


if ls $WHITEDOMAINSALL &> /dev/null;
then

  for f in $WHITEDOMAINSALL
  do

    BASEFILENAME=$(echo `basename $f | cut -f 1 -d '.'`)

    ## Dedupe and Sort
    cat -s $f | sort -u | gawk '{if (++dup[$0] == 1) print $0;}' > $TEMPFILEA
    mv $TEMPFILEA $f

    ## Add to Script.domains
    cat $f >> $WHITELISTTEMP

    HOWMANYLINES=$(echo -e "`wc -l $f | cut -d " " -f 1`")
    echo "$HOWMANYLINES In $BASEFILENAME" | sudo tee --append $RECENTRUN &>/dev/null
    printf "$yellow"  "$HOWMANYLINES In $BASEFILENAME"

  done

else
  echo "No Individual Whitelists Present."
  touch $WHITELISTTEMP
fi

## Total Whitelist
if [[ -f $WHITELISTTEMP ]]
then
  echo ""
  HOWMANYLINES=$(echo -e "`wc -l $WHITELISTTEMP | cut -d " " -f 1`")
  echo "$HOWMANYLINES To Whitelist" | sudo tee --append $RECENTRUN &>/dev/null
  printf "$yellow"  "$HOWMANYLINES To Whitelist"
else
  touch $WHITELISTTEMP
fi

## Dedupe merge
SCRIPTTEXT="Deduplicating Merged List."
printf "$cyan"    "$SCRIPTTEXT"
echo "### $SCRIPTTEXT" | sudo tee --append $RECENTRUN &>/dev/null
if [[ -f $WHITELISTTEMP ]]
then
  cat -s $WHITELISTTEMP | sort -u | gawk '{if (++dup[$0] == 1) print $0;}' > $TEMPFILER
  rm $WHITELISTTEMP
  mv $TEMPFILER $WHITELISTTEMP
else
  touch $WHITELISTTEMP
fi
HOWMANYLINES=$(echo -e "`wc -l $WHITELISTTEMP | cut -d " " -f 1`")
echo "$HOWMANYLINES After $SCRIPTTEXT" | sudo tee --append $RECENTRUN &>/dev/null
printf "$yellow"  "$HOWMANYLINES After $SCRIPTTEXT"
