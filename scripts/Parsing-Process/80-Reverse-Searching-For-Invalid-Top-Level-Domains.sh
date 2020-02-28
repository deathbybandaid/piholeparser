#!/bin/bash
## Invalid TLD's

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

printf "$yellow"  "This Process Normally Takes Longer Than The Others."

HOWMANYVALIDTLD=$(echo -e "`wc -l $TLDBKUP | cut -d " " -f 1`")

for source in `cat $TLDBKUP`;
do


  WHATLINENUMBER=$(echo "`grep -n $source $TLDBKUP | cut -d : -f 1`")
  #TLDPERCENTAGEMATH=$(echo `awk "BEGIN { pc=100*${WHATLINENUMBER}/${HOWMANYVALIDTLD}; i=int(pc); print (pc-i<0.5)?i:i+1}"`)

  HOWMANYTIMESTLD=$(echo -e "`grep -o [.]$source\$ $BFILETEMP | wc -l`")
  if [[ "$HOWMANYTIMESTLD" != 0 ]]
  then
    cat $BFILETEMP | grep -e [.]$source\$ >> $BTEMPFILE
  fi

  #echo -ne "$TLDPERCENTAGEMATH \r"

done

if [[ ! -f $BTEMPFILE ]]
then
  touch $BTEMPFILE
fi

## What doesn't make it through
if [[ -f $TRYNACATCHFIlES ]]
then
  rm $TRYNACATCHFIlES
fi

if [[ -f $BTEMPFILE && -f $BFILETEMP ]]
then
  gawk 'NR==FNR{a[$0];next} !($0 in a)' $BTEMPFILE $BFILETEMP >> $TRYNACATCHFIlES
fi

if [[ -f $BFILETEMP ]]
then
  rm $BFILETEMP
fi
