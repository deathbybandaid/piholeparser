#!/bin/bash
## Parsing loop

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

## Start time
STARTPARSESTAMP=$(date +"%s")
echo "STARTPARSESTAMP="$STARTPARSESTAMP"" | tee --append $TEMPPARSEVARS &>/dev/null

## Cheap error handling
if [[ -f $WFILETEMP ]]
then
  rm $WFILETEMP
fi
if [[ -f $WTEMPFILE ]]
then
  rm $WTEMPFILE
fi

## Transition File for Processing
if [[ -f $WORIGINALFILETEMP ]]
then
  cp $WORIGINALFILETEMP $WFILETEMP
fi

if [[ ! -f $WFILETEMP ]]
then
  touch $WFILETEMP
fi

HOWMANYLINES=$(echo -e "`wc -l $WFILETEMP | cut -d " " -f 1`")
if [[ $HOWMANYLINES -eq 0 ]]
then
  GOTOENDPARSING=true
  echo "GOTOENDPARSING="$GOTOENDPARSING"" | tee --append $TEMPPARSEVARS &>/dev/null
fi

## Start File Loop
## For .sh files In The actualparsing scripts Directory
echo ""
  for p in $PARSINGPROCESSSCRIPTSALL
  do

  PWASEFILENAME=$(echo `basename $p | cut -f 1 -d '.'`)
  PWASEFILENAMEDASHNUM=$(echo $PWASEFILENAME | sed 's/[0-9\-]/ /g')
  PWNAMEPRETTYSCRIPTTEXT=$(echo $PWASEFILENAMEDASHNUM)

  if [[ -f $TEMPPARSEVARS ]]
  then
    source $TEMPPARSEVARS
  fi

  if [[ -z $GOTOENDPARSING ]]
  then
    printf "$cyan"  "$PWNAMEPRETTYSCRIPTTEXT"
    echo "### $PWNAMEPRETTYSCRIPTTEXT" | tee --append $RECENTRUN &>/dev/null
    HOWMANYLINESSTART=$(echo -e "`wc -l $WFILETEMP | cut -d " " -f 1`")
    bash $p
    HOWMANYLINES=$(echo -e "`wc -l $WTEMPFILE | cut -d " " -f 1`")
    ENDCOMMENT="$HOWMANYLINES Lines After $PWNAMEPRETTYSCRIPTTEXT"
    echo "$ENDCOMMENT" | tee --append $RECENTRUN &>/dev/null

    if [[ $HOWMANYLINES -eq 0 && $HOWMANYLINESSTART -lt $HOWMANYLINES ]]
    then
      printf "$red"  "$ENDCOMMENT List File Now Empty."
      GOTOENDPARSING=true
      echo "GOTOENDPARSING="$GOTOENDPARSING"" | tee --append $TEMPPARSEVARS &>/dev/null
    elif [[ $HOWMANYLINES -gt 0 && $HOWMANYLINES -eq $HOWMANYLINESSTART ]]
    then
      printf "$yellow"    "$ENDCOMMENT"
    elif [[ $HOWMANYLINES -gt 0 && $HOWMANYLINES -lt $HOWMANYLINESSTART ]]
    then
      printf "$green"    "$ENDCOMMENT"
    fi

    mv $WTEMPFILE $WFILETEMP
    echo ""
  fi

  done

## End Time
ENDPARSESTAMP=$(date +"%s")
echo "ENDPARSESTAMP="$ENDPARSESTAMP"" | tee --append $TEMPPARSEVARS &>/dev/null

## Prepare for next step
if [[ -f $WFILETEMP ]]
then
  HOWMANYLINES=$(echo -e "`wc -l $WFILETEMP | cut -d " " -f 1`")
  if [[ $HOWMANYLINES -eq 0 ]]
  then
    PARSINGEMPTIEDFILE=true
    echo "PARSINGEMPTIEDFILE="$PARSINGEMPTIEDFILE"" | tee --append $TEMPPARSEVARS &>/dev/null
  elif [[ $HOWMANYLINES -ge 1 ]]
  then
    cp $WFILETEMP $WPARSEDFILETEMP
  fi
fi

## Cheap error handling
if [[ -f $WFILETEMP ]]
then
  rm $WFILETEMP
fi
if [[ -f $WTEMPFILE ]]
then
  rm $WTEMPFILE
fi
