#!/bin/bash
## Check online header

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

if  [[ -f $MIRROREDFILE && -z $PINGTESTFAILED ]]
then
  GOAHEADANDTEST=true
elif [[ ! -f $MIRROREDFILE && -z $PINGTESTFAILED ]]
then
  printf "$red"    "No Mirror File To Compare With, Proceeding with Download."
fi

## Check if file is modified since last download
if  [[ -n $GOAHEADANDTEST ]]
then
  MIRROREDFILESIZE=$(stat -c%s "$MIRROREDFILE")
  CURLFILESIZE=$(curl -s -H "$AGENTDOWNLOAD" $source | wc -c)
fi

if [[ -n $GOAHEADANDTEST && `curl -s -H "$AGENTDOWNLOAD" -z "$MIRROREDFILE" -o /dev/null -I -w "%{http_code}" "$source" | grep '304'` ]]
then
  printf "$green"    "Source Date Not Newer."
  TESTCURLDATESAME=true
else
  printf "$red"    "Source Date Is Newer."
fi

if [[ -n $GOAHEADANDTEST && $MIRROREDFILESIZE -ge $CURLFILESIZE ]]
then
  printf "$green"    "File Size Is The Same."
  TESTCURLSIZESAME=true
elif [[ -n $GOAHEADANDTEST && $MIRROREDFILESIZE != $CURLFILESIZE ]]
then
  printf "$red"    "File Size Is Different."
fi

if [[ -n $TESTCURLSIZESAME || -n $TESTCURLDATESAME ]]
then
  SKIPDOWNLOAD=true
fi

echo ""
if [[ -n $GOAHEADANDTEST && -n $SKIPDOWNLOAD ]]
then
  printf "$green"    "File Not Updated Online. No Need To Download."
  echo "SKIPDOWNLOAD="$SKIPDOWNLOAD"" | tee --append $TEMPPARSEVARS &>/dev/null
else
  printf "$yellow"    "File Has Changed Online."
fi

if [[ -f $MIRROREDFILE && -f $PARSEDFILE && -n $SKIPDOWNLOAD ]]
then
  printf "$green"    "Since Parsed File is Present, There Is No Need To Process."
  FULLSKIPPARSING=true
  echo "FULLSKIPPARSING="$FULLSKIPPARSING"" | tee --append $TEMPPARSEVARS &>/dev/null
fi
