#!/bin/bash
## 

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

if [[ -f $TEMPPARSEVARS ]]
then
  rm $TEMPPARSEVARS
fi
