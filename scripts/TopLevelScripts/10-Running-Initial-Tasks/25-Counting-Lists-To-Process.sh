#!/bin/bash
## This Recreates The SourceList

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

SCRIPTTEXT="Checking For Big Source List File."
printf "$cyan"    "$SCRIPTTEXT"
echo "### $SCRIPTTEXT" | tee --append $RECENTRUN &>/dev/null
if [[ -f $COMBINEDBLACKLISTSSOURCE ]]
then
  rm $COMBINEDBLACKLISTSSOURCE
  printf "$red"    "Purging Old Source List."
  echo "* Old Multisource List Purged." | tee --append $RECENTRUN &>/dev/null
fi
echo ""

SCRIPTTEXT="Merging Sources."
printf "$cyan"    "$SCRIPTTEXT"
echo "### $SCRIPTTEXT" | tee --append $RECENTRUN &>/dev/null
CHECKME=$BLACKLSTALL
if ls $CHECKME &> /dev/null;
then
  cat $BLACKLSTALL | sort | sed '/^$/d' >> $COMBINEDBLACKLISTSSOURCE
else
  touch $COMBINEDBLACKLISTSSOURCE
fi
HOWMANYLINES=$(echo -e "`wc -l $COMBINEDBLACKLISTSSOURCE | cut -d " " -f 1`")
echo "$HOWMANYLINES After $SCRIPTTEXT" | tee --append $RECENTRUN &>/dev/null
echo ""

## Math Time
if [[ -f $COMBINEDBLACKLISTSSOURCE ]]
then
  HOWMANYSOURCELISTS=$(echo -e "`wc -l $COMBINEDBLACKLISTSSOURCE | cut -d " " -f 1`")
else
  HOWMANYSOURCELISTS="unknown amount"
fi
HOWMANYSOURCE="$HOWMANYSOURCELISTS"

## Save to Tempvars
echo "HOWMANYSOURCELISTS='"$HOWMANYSOURCELISTS"'" | tee --append $TEMPVARS &>/dev/null
echo "HOWMANYSOURCE='"$HOWMANYSOURCE"'" | tee --append $TEMPVARS &>/dev/null

## Log Activity
echo "* $HOWMANYSOURCE Lists To Be Processed." | tee --append $RECENTRUN &>/dev/null

## Terminal Display
printf "$yellow"    "$HOWMANYSOURCE Lists To Be Processed."
