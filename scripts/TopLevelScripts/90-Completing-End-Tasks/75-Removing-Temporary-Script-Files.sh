#!/bin/bash
## Remove TempVars

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

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
