#!/bin/bash
## Checks if github mirror present

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

if [[ `wget -S --spider $MIRROREDFILEDL  2>&1 | grep 'HTTP/1.1 200 OK'` ]]
then
  printf "$green"  "Github Mirror File Currently Available."
  GITFILEONLINE=true
  echo "GITFILEONLINE="$GITFILEONLINE"" | tee --append $TEMPPARSEVARS &>/dev/null
else
  printf "$red"  "Github Mirror File Currently Unavailable."
fi
