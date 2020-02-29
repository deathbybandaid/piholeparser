#!/bin/bash
## This Pushes Changes To Github

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


## Push Changes up to Github
if  [ "$version" = "github" ]
then
  printf "$green"   "Pushing Lists to Github"
  timestamp=$(echo `date`)
  printf "$green"    "$(git -C $git_local_repo_path remote set-url origin $git_repo_url_push)"
  printf "$green"    "$(git -C $git_local_repo_path add .)"
  printf "$green"    "$(git -C $git_local_repo_path commit -m "Update lists $timestamp")"
  printf "$green"    "$(git -C $git_local_repo_path push -u origin $git_repo_branch)"
elif [ "$version" = "local" ]
then
  printf "$yellow"   "Not Pushing Lists to Github"
fi
