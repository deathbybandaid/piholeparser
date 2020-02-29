#!/bin/bash
## This script resides outside of the main directory
## for the purpose of updating without worrying about being overwritten
##
## This File will not be updated often.

## Variables
git_repo_name=piholeparser
OUTSIDEDIRVARS=/etc/"$git_repo_name".sh
if [[ -f "$OUTSIDEDIRVARS" ]]
then
  echo "Main Vars Check Successful"
  source $OUTSIDEDIRVARS
else
  echo "Main Vars File Missing, Exiting."
  exit
fi

if [[ ! -d "$git_local_repo_path" ]]
then
  echo ""
  echo "$git_repo_name Directory Missing. Cloning Now."
  echo ""
  git clone $git_repo_url_b $git_local_repo_path
fi

SCRIPTVARSDIR="$git_local_repo_path"scripts/scriptvars/
STATICVARS="$SCRIPTVARSDIR"staticvariables.sh
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
printf "$green"    "$(git -C $git_local_repo_path pull)"
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
