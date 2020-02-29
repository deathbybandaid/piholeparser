#!/bin/bash
# shellcheck disable=SC1090,SC2034,SC2154

## Variables
script_dir=$(dirname $0)
SCRIPTVARSDIR="$script_dir"/../scriptvars/
STATICVARS="$SCRIPTVARSDIR"staticvariables.sh
if
[[ -f $STATICVARS ]]
then
  source $STATICVARS
else
  echo "Static Vars File Missing, Exiting."
  exit
fi

## whiptail required
WHATITIS=whiptail
WHATPACKAGE=whiptail
if
which $WHATITIS >/dev/null;
then
  :
else
  printf "$yellow"  "Installing $WHATITIS"
  apt-get install -y $WHATPACKAGE
fi
