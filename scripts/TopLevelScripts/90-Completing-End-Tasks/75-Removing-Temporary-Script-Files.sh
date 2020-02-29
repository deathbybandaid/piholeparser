#!/bin/bash
# shellcheck disable=SC1090,SC2034,SC2154

## Remove TempVars

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.sh

CHECKME=$TEMPVARS
if ls $CHECKME &> /dev/null;
then
  rm $CHECKME
fi


CHECKME=$TEMPCLEANUPONE
if ls $CHECKME &> /dev/null;
then
  rm $CHECKME
fi

CHECKME=$TEMPCLEANUPTWO
if ls $CHECKME &> /dev/null;
then
  rm $CHECKME
fi

CHECKME=$TEMPCLEANUPTHREE
if ls $CHECKME &> /dev/null;
then
  rm $CHECKME
fi
