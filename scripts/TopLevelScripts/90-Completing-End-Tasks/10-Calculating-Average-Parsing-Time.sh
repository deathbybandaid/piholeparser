#!/bin/bash
## average parsing time

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

if [[ -f $PARSEAVERAGEFILETIME ]]
then
  AVERAGEPARSETIME=$(echo `awk '{ total += $1; count++ } END { print total/count }' $PARSEAVERAGEFILETIME`)
  AVERAGEPARSENUM=$(echo -e "`wc -l $PARSEAVERAGEFILETIME | cut -d " " -f 1`")
fi

if [[ -z $AVERAGEPARSETIME ]]
then
  AVERAGEPARSETIME="unknown"
fi
echo "AVERAGEPARSETIME='"$AVERAGEPARSETIME"'" | tee --append $TEMPVARS &>/dev/null

if [[ -z $AVERAGEPARSENUM ]]
then
  AVERAGEPARSENUM="unknown"
fi
echo "AVERAGEPARSENUM='"$AVERAGEPARSENUM"'" | tee --append $TEMPVARS &>/dev/null
printf "$yellow"   "Average Parsing Time Of $AVERAGEPARSENUM Lists Was $AVERAGEPARSETIME Seconds."

echo "* Average Parsing Time Of $AVERAGEPARSENUM Lists Was $AVERAGEPARSETIME Seconds." | tee --append $RECENTRUN &>/dev/null

if ls $PARSEAVERAGEFILETIME &> /dev/null;
then
  rm $PARSEAVERAGEFILETIME
fi
