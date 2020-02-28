#!/bin/bash
## Push to local location

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

WHATITIS="Localhost Web Directory"
CHECKME=$LOCALHOSTDIR
timestamp=$(echo `date`)
if [[ -z $CHECKME ]]
then
  echo "* $WHATITIS Not Set. Please Fix. $timestamp" | tee --append $RECENTRUN &>/dev/null
  echo "Local Host Web Directory Not Set."
  exit
fi
if
  ls $CHECKME &> /dev/null;
then
  echo "* $WHATITIS Already there no need to mkdir. $timestamp" | tee --append $RECENTRUN &>/dev/null
else
  echo "* $WHATITIS Not There. Please Fix. $timestamp" | tee --append $RECENTRUN &>/dev/null
  exit
fi

WHATITIS="Locally Hosted Biglist"
CHECKME=$CLOCALHOST
timestamp=$(echo `date`)
if ls $CHECKME &> /dev/null;
then
  rm $CHECKME
  echo "* $WHATITIS Removed. $timestamp" | tee --append $RECENTRUN &>/dev/null
else
  echo "* $WHATITIS Not Removed. $timestamp" | tee --append $RECENTRUN &>/dev/null
fi
## Copy it over
CHECKME=$CLOCALHOST
if ls $CHECKME &> /dev/null;
then
  cp -p $COMBINEDBLACKLISTS $CLOCALHOST
else
  echo "* $WHATITIS Not Created. $timestamp" | tee --append $RECENTRUN &>/dev/null
fi

WHATITIS="Locally Hosted Biglist (Edited)"
CHECKME=$DBBLOCALHOST
timestamp=$(echo `date`)
if ls $CHECKME &> /dev/null;
then
  rm $CHECKME
  echo "* $WHATITIS Removed. $timestamp" | tee --append $RECENTRUN &>/dev/null
else
  echo "* $WHATITIS Not Removed. $timestamp" | tee --append $RECENTRUN &>/dev/null
fi
## Copy it over
CHECKME=$DBBLOCALHOST
if ls $CHECKME &> /dev/null;
then
  cp -p $COMBINEDBLACKLISTSDBB $DBBLOCALHOST
else
  echo "* $WHATITIS Not Created. $timestamp" | tee --append $RECENTRUN &>/dev/null
fi
