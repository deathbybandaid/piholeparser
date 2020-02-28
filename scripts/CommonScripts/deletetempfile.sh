#!/bin/bash
## This should be run alot, to make sure the temp folder doesn't get screwed up

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

CHECKME=$TEMPCLEANUPONE
if ls $CHECKME &> /dev/null;
then
  rm $CHECKME
  echo ""
fi

CHECKME=$COMPRESSEDTEMPSEVEN
if ls $CHECKME &> /dev/null;
then
  rm $CHECKME
  echo ""
fi

CHECKME=$COMPRESSEDTEMPTAR
if ls $CHECKME &> /dev/null;
then
  rm $CHECKME
  echo ""
fi
