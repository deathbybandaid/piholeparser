#!/bin/bash
## TLD Percentages

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

COMBINEDBLACKLISTSHOWMANY=$(echo -e "`wc -l $COMBINEDBLACKLISTS | cut -d " " -f 1`")
HOWMANYVALIDTLD=$(echo -e "`wc -l $TLDBKUP | cut -d " " -f 1`")

for source in `cat $TLDBKUP`;
do

  WHATLINENUMBER=$(echo "`grep -n $source $TLDBKUP | cut -d : -f 1`")
  TLDPERCENTAGEMATH=$(echo `awk "BEGIN { pc=100*${WHATLINENUMBER}/${HOWMANYVALIDTLD}; i=int(pc); print (pc-i<0.5)?i:i+1}"`)

  HOWMANYTIMESTLD=$(echo -e "`grep -o [.]$source\$ $COMBINEDBLACKLISTS | wc -l`")
  if [[ "$HOWMANYTIMESTLD" != 0 ]]
  then
    TLDPERCENTAGERESULT=$(echo `awk "BEGIN { pc=100*${HOWMANYTIMESTLD}/${COMBINEDBLACKLISTSHOWMANY}; i=int(pc); print (pc-i<0.5)?i:i+1}"`)
    if [[ "$TLDPERCENTAGERESULT" != 0 ]]
    then
      echo "$TLDPERCENTAGERESULT % ."$source"" | tee --append $TEMPFILEN &>/dev/null
    elif [[ "$TLDPERCENTAGERESULT" == 0 ]]
    then
      echo "0.5 % ."$source"" | tee --append $TEMPFILEN &>/dev/null
    fi
  fi

  #echo -ne "$TLDPERCENTAGEMATH \r"

done

echo "________________________________________________" | tee --append $RECENTRUN &>/dev/null
if [[ -f $TEMPFILEN ]]
then
  cat -s $TEMPFILEN | sort -n > $TEMPFILEM
else
  touch $TEMPFILEM
fi

if [[ -f $TEMPFILEM ]]
then
  tac $TEMPFILEM >> $TEMPFILEP
else
  touch $TEMPFILEP
fi

if [[ -f $TEMPFILEP ]]
then
  for source in `cat $TEMPFILEP`;
  do
    echo "* '$source'" | tee --append $RECENTRUN &>/dev/null
  done
fi
