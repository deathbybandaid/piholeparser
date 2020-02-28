#!/bin/bash
## This Pushes Changes To Github

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


## Push Changes up to Github
if  [ "$version" = "github" ]
then
  printf "$green"   "Pushing Lists to Github"
  timestamp=$(echo `date`)
  printf "$green"    "$(git -C $REPODIR remote set-url origin $GITWHERETOPUSH)"
  printf "$green"    "$(git -C $REPODIR add .)"
  printf "$green"    "$(git -C $REPODIR commit -m "Update lists $timestamp")"
  printf "$green"    "$(git -C $REPODIR push -u origin $REPOBRANCH)"
elif [ "$version" = "local" ]
then
  printf "$yellow"   "Not Pushing Lists to Github"
fi
