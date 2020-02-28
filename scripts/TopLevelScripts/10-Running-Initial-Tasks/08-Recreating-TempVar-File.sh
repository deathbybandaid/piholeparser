#!/bin/bash
## This Recreates The Temporary Variables

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

SCRIPTTEXT="Checking For Old TempVars File."
printf "$cyan"    "$SCRIPTTEXT"
echo "### $SCRIPTTEXT" | tee --append $RECENTRUN &>/dev/null
if [[ -f $TEMPVARS ]]
then
  rm $TEMPVARS
  printf "$red"   "Purging Old TempVars File."
  echo "* Old TempVars File Purged." | tee --append $RECENTRUN &>/dev/null
else
  echo "* Old TempVars File Not Present." | tee --append $RECENTRUN &>/dev/null
fi
echo "" | tee --append $RECENTRUN &>/dev/null
echo ""

SCRIPTTEXT="Checking For Other Temp Vars Files."
printf "$cyan"    "$SCRIPTTEXT"
echo "### $SCRIPTTEXT" | tee --append $RECENTRUN &>/dev/null
CHECKME=$TEMPCLEANUPTHREE
if ls $CHECKME &> /dev/null;
then
  echo "* Other Temp Vars Files Purged." | tee --append $RECENTRUN &>/dev/null
  rm $CHECKME
else
  echo "* Other Temp Vars Files Purged." | tee --append $RECENTRUN &>/dev/null
fi
echo "" | tee --append $RECENTRUN &>/dev/null
echo ""

echo "## Vars that we don't keep" | tee --append $TEMPVARS &>/dev/null

SCRIPTTEXT="Checking For TempVars File."
printf "$cyan"    "$SCRIPTTEXT"
echo "### $SCRIPTTEXT" | tee --append $RECENTRUN &>/dev/null
if [[ -f $TEMPVARS ]]
then
  printf "$yellow"   "TempVars File Recreated."
  echo "* TempVars File Recreated." | tee --append $RECENTRUN &>/dev/null
else
  printf "$red"   "TempVars File Missing, Exiting."
  echo "* TempVars Files Missing, Script Exited." | tee --append $RECENTRUN &>/dev/null
  exit
fi
