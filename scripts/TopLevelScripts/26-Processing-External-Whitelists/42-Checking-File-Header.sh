#!/bin/bash
## Check File Headers

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

#HTTPCODECURL=`curl -s -o /dev/null -I -w "%{http_code}" $source`
#HTTPCODEWGET=`wget --server-response $source 2>&1 | awk '/^  HTTP/{print $2}'`

#if [[ $HTTPCODECURL == 200 || $HTTPCODEWGET == 200 ]]
#then
  #echo "yes"
#else
  #echo "no"
#fi

## curl Header
if [[ `curl -s -H "$AGENTDOWNLOAD" -o /dev/null -I -w "%{http_code}" $source | grep '200'` ]]
then
  printf "$green"  "Curl Header Check Successful."
else
  printf "$red"  "Curl Header Check Unsuccessful."
  TESTCURLHEADERFAILED=true
  echo "TESTCURLHEADERFAILED="$TESTCURLHEADERFAILED"" | tee --append $TEMPPARSEVARS &>/dev/null
fi

## wget header
if [[ `wget -S --header="$AGENTDOWNLOAD" --spider $source  2>&1 | grep 'HTTP/1.1 200 OK'` ]]
then
  printf "$green"  "Wget Header Check Successful."
else
  printf "$red"  "Wget Header Check Unsuccessful."
  TESTWGETHEADERFAILED=true
  echo "TESTWGETHEADERFAILED="$TESTWGETHEADERFAILED"" | tee --append $TEMPPARSEVARS &>/dev/null
fi
