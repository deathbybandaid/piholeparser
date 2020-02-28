#!/bin/bash
##

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

## If $SOURCEDOMAIN is set, Ping it
if [[ -n $SOURCEDOMAIN ]]
then
  SOURCEIPFETCH=`ping -c 1 $SOURCEDOMAIN | gawk -F'[()]' '/PING/{print $2}'`
  SOURCEIP=`echo $SOURCEIPFETCH`
  echo "SOURCEIP="$SOURCEIP"" | tee --append $TEMPPARSEVARS &>/dev/null
fi

if [[ -n $SOURCEIP ]]
then
  printf "$green"    "Ping Test Was A Success!"
elif [[ -z $SOURCEIP ]]
then
  printf "$red"    "Ping Test Failed."
  PINGTESTFAILEDA=true
  echo "PINGTESTFAILEDA="$PINGTESTFAILEDA"" | tee --append $TEMPPARSEVARS &>/dev/null
fi

if [[ -n $PINGTESTFAILEDA  ]]
then
  if [[ `wget -S --spider $source  2>&1 | grep 'HTTP/1.1 200 OK'` ]]
  then
    printf "$green"  "Header Check Successful."
  else
    printf "$red"  "Header Check Unsuccessful."
    PINGTESTFAILED=true
    echo "PINGTESTFAILED="$PINGTESTFAILED"" | tee --append $TEMPPARSEVARS &>/dev/null
  fi
fi
