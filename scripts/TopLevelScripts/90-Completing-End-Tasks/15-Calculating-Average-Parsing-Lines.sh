#!/bin/bash
## average parsing time

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

if [[ -f $PARSEAVERAGEFILELINES ]]
then
  AVERAGEPARSELINES=$(echo `awk '{ total += $1; count++ } END { print total/count }' $PARSEAVERAGEFILELINES`)
fi

if [[ -z $AVERAGEPARSELINES ]]
then
  AVERAGEPARSELINES="unknown"
fi
echo "AVERAGEPARSELINES='"$AVERAGEPARSELINES"'" | tee --append $TEMPVARS &>/dev/null

echo "* Average Parsing Lines was "$AVERAGEPARSELINES"." | tee --append $RECENTRUN &>/dev/null

printf "$yellow"   "Average Parsing Lines was "$AVERAGEPARSELINES"."

if ls $PARSEAVERAGEFILELINES &> /dev/null;
then
  rm $PARSEAVERAGEFILELINES
fi
