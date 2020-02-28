#!/bin/bash
## Sets The Beginning Script Time

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

timestamp=$(echo `date`)
STARTTIME=$(echo `date`)
echo "STARTTIME='$timestamp'" | tee --append $TEMPVARS &>/dev/null

STARTIMEVAR=$(echo $STARTIME)
STARTTIMESTAMP=$(date +"%s")

echo "STARTIMEVAR='"$STARTIMEVAR"'" | tee --append $TEMPVARS &>/dev/null
echo "STARTTIMESTAMP=$STARTTIMESTAMP" | tee --append $TEMPVARS &>/dev/null

printf "$yellow" "Script Started At $STARTTIME"
echo "* Start Time Set To $timestamp" | tee --append $RECENTRUN &>/dev/null
