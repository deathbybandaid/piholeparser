#!/bin/bash
## This Modifies Config File Variables

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.sh

if
[[ -f $OUTSIDEDIRVARS ]]
then
  source $OUTSIDEDIRVARS
else
  echo "Outside Vars File Missing, Creating."
  cp /etc/"$git_repo_name"/scripts/scriptvars/"$OUTSIDEDIRVARS" "$OUTSIDEDIRVARS"
fi

# check for variable
if [ -z "$1" ]
  then
    echo "No Variable Supplied"
    exit
fi

# check for value
if [ -z "$2" ]
  then
    echo "No Value Supplied"
    exit
fi

source $OUTSIDEDIRVARS

# add variable to config if missing
if [ -z "${!1}" ]
  then
    echo "Variable Missing From Config, creating it."
    echo ""$1"="$2"" | tee --append "$OUTSIDEDIRVARS" >/dev/null;
  else
    echo "Variable exists in Config, replacing it."
    sed -i "s/^\($1\s*=\s*\).*\$/\1$2/" $OUTSIDEDIRVARS >/dev/null;
fi
