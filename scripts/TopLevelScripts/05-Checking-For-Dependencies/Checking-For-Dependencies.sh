#!/bin/bash
## This is where any script dependencies will go.
## It checks if it is installed, and if not,
## it installs the program

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/../foldervars.var

DEPENDENCIESALL="$COMPLETEFOLDERPATH"/*.dep

## Start File Loop
## For .dependency files In The dependencies Directory
for f in $DEPENDENCIESALL
do

  timestamp=$(echo `date`)

  ## Name Of Package
  DEPENDENCYNAME=$(echo `basename $f | cut -f 1 -d '.'`)

  ## Actual Package
  DEPENDENCYPACKAGE=`cat $f`

  echo ""
  printf "$cyan"  "Checking For $DEPENDENCYNAME"
  echo "## $DEPENDENCYNAME $timestamp" | tee --append $RECENTRUN &>/dev/null

  if which $DEPENDENCYNAME >/dev/null;
  then
    printf "$yellow"  "$DEPENDENCYNAME Is Already Installed."
    echo "$DEPENDENCYNAME Already Installed $timestamp" | tee --append $RECENTRUN &>/dev/null
  else
    echo "Installing $DEPENDENCYNAME $timestamp" | tee --append $RECENTRUN &>/dev/null
    printf "$yellow"  "Installing $DEPENDENCYNAME"
    apt-get install -y $DEPENDENCYPACKAGE
  fi

  if which $DEPENDENCYNAME >/dev/null;
  then
    :
  else
    echo "Error Installing $DEPENDENCYNAME $timestamp" | tee --append $RECENTRUN &>/dev/null
    printf "$red"  "Error Installing $DEPENDENCYNAME"
  fi

## End Of loop
done
