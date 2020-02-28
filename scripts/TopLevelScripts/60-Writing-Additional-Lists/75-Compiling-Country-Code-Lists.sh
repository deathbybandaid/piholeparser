#!/bin/bash
## This spits out lists based on country codes

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

## Check if combined list is present
if [[ ! -f $COMBINEDBLACKLISTSDBB ]]
then
  printf "$red"  "DBB List File Missing."
  touch $COMBINEDBLACKLISTSDBB
fi

## Process Every .clist file within CountryCode List Directory
if ls $COUNTRYCODESTLDALL &> /dev/null;
then

for f in $COUNTRYCODESTLDALL
do

  # Dynamic Variables
  BASEFILENAME=$(echo `basename $f | cut -f 1 -d '.'`)
  COUNTRYCODECOMPLETE="$COUNTRYCODESSUBSDIR""$BASEFILENAME".txt

  for source in `cat $f`;
  do

    HOWMANYTIMESTLD=$(echo -e "`grep -o [.]$source\$ $COMBINEDBLACKLISTSDBB | wc -l`")

    if [[ "$HOWMANYTIMESTLD" != 0 ]]
    then
      cat $COMBINEDBLACKLISTSDBB | grep -e [.]$source\$ >> $TEMPFILEZ
      touch $TEMPFILEZ
      if [[ -f $TEMPFILEZ ]]
      then
        HOWMANYTIMESTLDAFTER=$(echo -e "`grep -o [.]$source\$ $TEMPFILEZ | wc -l`")
        printf "$yellow"  "$BASEFILENAME Has $HOWMANYTIMESTLDAFTER Domains Using ."$source""
      fi
    fi

  ## End Source Loop
  done

  if [[ -f $TEMPFILEZ ]]
  then
    touch $TEMPFILEZ
    cat $TEMPFILEZ | sed 's/\s\+$//; /^$/d; /[[:blank:]]/d' > $TEMPFILEY
    rm $TEMPFILEZ
  fi

  if [[ ! -f $TEMPFILEY ]]
  then
    touch $TEMPFILEY
  fi
    HOWMANYLINES=$(echo -e "`wc -l $TEMPFILEY | cut -d " " -f 1`")

  if [[ $HOWMANYLINES -gt 0 && -f $COUNTRYCODECOMPLETE ]]
  then
    rm $COUNTRYCODECOMPLETE
  fi

  if [[ $HOWMANYLINES -gt 0 ]]
  then
    mv $TEMPFILEY $COUNTRYCODECOMPLETE
  else
    rm $TEMPFILEY
  fi

## End File loop
done

else
echo "No Country Code Presets Present."
fi
