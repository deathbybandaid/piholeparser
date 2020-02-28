#!/bin/bash
## Pinging Host

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

## If $SOURCEDOMAIN is set, Ping it
if [[  -n $SOURCEDOMAIN && `ping -c 1 $SOURCEDOMAIN | gawk -F'[()]' '/PING/{print $2}'` ]]
then
  printf "$green"    "Ping Test Was A Success!"
  SOURCEIPFETCH=`ping -c 1 $SOURCEDOMAIN | gawk -F'[()]' '/PING/{print $2}'`
  SOURCEIP=`echo $SOURCEIPFETCH`
  echo "SOURCEIP="$SOURCEIP"" | tee --append $TEMPPARSEVARS &>/dev/null
else
  printf "$red"    "Ping Test Failed."
  SOURCEIP="unknown"
  echo "SOURCEIP="$SOURCEIP"" | tee --append $TEMPPARSEVARS &>/dev/null
  TESTPINGFAILED=true
  echo "TESTPINGFAILED="$TESTPINGFAILED"" | tee --append $TEMPPARSEVARS &>/dev/null
fi
