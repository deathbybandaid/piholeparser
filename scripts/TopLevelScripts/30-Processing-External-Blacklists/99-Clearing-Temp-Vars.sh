#!/bin/bash
## 

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.sh

if [[ -f $TEMPPARSEVARS ]]
then
  rm $TEMPPARSEVARS
fi
