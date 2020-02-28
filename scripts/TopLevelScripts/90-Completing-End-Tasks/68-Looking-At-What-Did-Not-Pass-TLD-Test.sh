#!/bin/bash
## TLD didnt pass

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

if [[ -f $TRYNACATCHFIlES ]]
then
  printf "$yellow"  "Removing duplicates."
  cat -s $TRYNACATCHFIlES | sort -u | gawk '{if (++dup[$0] == 1) print $0;}' >> $FILETEMP
  HOWMANYLINES=$(echo -e "`wc -l $FILETEMP | cut -d " " -f 1`")
  printf "$yellow"    "$HOWMANYLINES Lines After Deduping."
  echo "* $HOWMANYLINES Lines After Deduping. $timestamp" | tee --append $RECENTRUN &>/dev/null
  echo "____________________________________________________" | tee --append $RECENTRUN &>/dev/null
  for source in `cat $FILETEMP`;
  do
    echo "* $source" | tee --append $RECENTRUN &>/dev/null
  done
  rm $FILETEMP
else
  printf "$yellow"  "Either all lines past TLD test, or the file is missing."
fi
