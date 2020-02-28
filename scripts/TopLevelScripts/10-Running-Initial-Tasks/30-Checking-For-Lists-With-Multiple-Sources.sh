#!/bin/bash
## This will log lists with more than one source

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

## Process Every .lst file within the List Directories
if ls $BLACKLSTALL &> /dev/null;
then
  for f in $BLACKLSTALL
  do

  BASEFILENAME=$(echo `basename $f | cut -f 1 -d '.'`)

  ## Amount of sources greater than one?
  timestamp=$(echo `date`)
  HOWMANYLINES=$(echo -e "`wc -l $f | cut -d " " -f 1`")
  if [[ "$HOWMANYLINES" -gt 1 ]]
  then
    echo "* $BASEFILENAME Has $HOWMANYLINES sources. $timestamp" | tee --append $MORETHANONESOURCE &>/dev/null
  fi

  done
else
  printf "$green"   "No Lists to Process."
  echo "No Lists to Process." | tee --append $RECENTRUN &>/dev/null
fi

if  [[ -f $MORETHANONESOURCE ]]
then
  printf "$yellow"   "Multi-Source List Recreated."
  echo "* Multi-Source List Recreated" | tee --append $RECENTRUN &>/dev/null
  HOWMANYLISTSWITHMULTSOURCE=$(echo -e "`wc -l $MORETHANONESOURCE | cut -d " " -f 1`")
  HOWMANYLISTSWITHMULTSOURCEB=$(expr $HOWMANYLISTSWITHMULTSOURCE - 1)
  echo ""
  printf "$yellow"    "$HOWMANYLISTSWITHMULTSOURCEB Lists With More Than One Source. See Log For Details."
  echo "$HOWMANYLISTSWITHMULTSOURCEB Lists With More Than One Source." | tee --append $RECENTRUN &>/dev/null
  echo "_________________________________________" | tee --append $RECENTRUN &>/dev/null
  cat $MORETHANONESOURCE >> $RECENTRUN
  rm $MORETHANONESOURCE
else
  echo "_________________________________________" | tee --append $RECENTRUN &>/dev/null
  printf "$green"   "All Lists Only Have One Source."
  echo "All Lists Only Have One Source." | tee --append $RECENTRUN &>/dev/null
fi
