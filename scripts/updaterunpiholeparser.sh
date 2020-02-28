#!/bin/bash
## This script resides outside of the main directory 
## for the purpose of updating without worrying about being overwritten
##
## This File will not be updated often.

## Variables
REPONAME=piholeparser
MAINVAR=/etc/"$REPONAME".var
if [[ -f "$MAINVAR" ]]
then
  echo "Main Vars Check Successful"
  source $MAINVAR
else
  echo "Main Vars File Missing, Exiting."
  exit
fi

if [[ ! -d "$REPODIR" ]]
then
  echo ""
  echo "$REPONAME Directory Missing. Cloning Now."
  echo ""
  git clone $GITREPOSITORYURLB $REPODIR
fi

SCRIPTVARSDIR="$REPODIR"scripts/scriptvars/
STATICVARS="$SCRIPTVARSDIR"staticvariables.var
if [[ -f $STATICVARS ]]
then
  source $STATICVARS
else
  echo "Static Vars File Missing, Exiting."
  exit
fi

printf "$blue"    "$DIVIDERBAR"
echo ""
printf "$cyan"    "Updating Repository."
echo ""
printf "$green"    "$(git -C $REPODIR pull)"
echo ""
printf "$magenta" "$DIVIDERBAR"
echo ""

## RunParser
if [[ -f $TOPRUNSCRIPT ]]
then
  bash $TOPRUNSCRIPT
else
  echo "$TOPRUNSCRIPT Missing, Exiting."
  exit
fi
