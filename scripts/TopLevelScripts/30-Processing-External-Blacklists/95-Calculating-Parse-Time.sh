#!/bin/bash
## Calculate Parse Time

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

## end time
DIFFTIMEPARSESEC=`expr $ENDPARSESTAMP - $STARTPARSESTAMP`
DIFFTIMEPARSE=`expr $DIFFTIMEPARSESEC / 60`
echo "$DIFFTIMEPARSESEC" | tee --append $PARSEAVERAGEFILETIME &>/dev/null

if [[ $DIFFTIMEPARSESEC -gt 60 ]]
then
  printf "$yellow"   "List took $DIFFTIMEPARSE Minutes To Parse."
else
  printf "$yellow"   "List took $DIFFTIMEPARSESEC Seconds To Parse."
fi
