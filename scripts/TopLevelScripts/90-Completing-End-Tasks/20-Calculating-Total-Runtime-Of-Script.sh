#!/bin/bash
## total runtime

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

timestamp=$(echo `date`)
ENDTIME=$(echo `date`)
echo "ENDTIME='$timestamp'" | tee --append $TEMPVARS &>/dev/null

ENDTIMESTAMP=$(date +"%s")
DIFFTIMESEC=`expr $ENDTIMESTAMP - $STARTTIMESTAMP`
DIFFTIME=`expr $DIFFTIMESEC / 60`

TOTALRUNTIME=$DIFFTIME
echo "* $TOTALRUNTIME" | tee --append $RECENTRUN &>/dev/null
echo "TOTALRUNTIME='"$TOTALRUNTIME"'" | tee --append $TEMPVARS &>/dev/null

printf "$yellow"   "$TOTALRUNTIME"
