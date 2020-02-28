#!/bin/bash
## Parsing loop

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

## Start time
STARTPARSESTAMP=$(date +"%s")
echo "STARTPARSESTAMP="$STARTPARSESTAMP"" | tee --append $TEMPPARSEVARS &>/dev/null

## Cheap error handling
if [[ -f $BFILETEMP ]]
then
  rm $BFILETEMP
fi
if [[ -f $BTEMPFILE ]]
then
  rm $BTEMPFILE
fi

## Transition File for Processing
if [[ -f $BORIGINALFILETEMP ]]
then
  cp $BORIGINALFILETEMP $BFILETEMP
fi

if [[ ! -f $BFILETEMP ]]
then
  touch $BFILETEMP
fi

HOWMANYLINES=$(echo -e "`wc -l $BFILETEMP | cut -d " " -f 1`")
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

  PBASEFILENAME=$(echo `basename $p | cut -f 1 -d '.'`)
  PBASEFILENAMEDASHNUM=$(echo $PBASEFILENAME | sed 's/[0-9\-]/ /g')
  PBNAMEPRETTYSCRIPTTEXT=$(echo $PBASEFILENAMEDASHNUM)

  if [[ -f $TEMPPARSEVARS ]]
  then
    source $TEMPPARSEVARS
  fi

  if [[ -z $GOTOENDPARSING ]]
  then
    printf "$cyan"  "$PBNAMEPRETTYSCRIPTTEXT"
    echo "### $PBNAMEPRETTYSCRIPTTEXT" | tee --append $RECENTRUN &>/dev/null
    HOWMANYLINESSTART=$(echo -e "`wc -l $BFILETEMP | cut -d " " -f 1`")
    bash $p
    HOWMANYLINES=$(echo -e "`wc -l $BTEMPFILE | cut -d " " -f 1`")
    ENDCOMMENT="$HOWMANYLINES Lines After $PBNAMEPRETTYSCRIPTTEXT"
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

    mv $BTEMPFILE $BFILETEMP
    echo ""
  fi

done

## End Time
ENDPARSESTAMP=$(date +"%s")
echo "ENDPARSESTAMP="$ENDPARSESTAMP"" | tee --append $TEMPPARSEVARS &>/dev/null

## Prepare for next step
if [[ -f $BFILETEMP ]]
then
HOWMANYLINES=$(echo -e "`wc -l $BFILETEMP | cut -d " " -f 1`")
  if [[ $HOWMANYLINES -eq 0 ]]
  then
    PARSINGEMPTIEDFILE=true
    echo "PARSINGEMPTIEDFILE="$PARSINGEMPTIEDFILE"" | tee --append $TEMPPARSEVARS &>/dev/null
  elif [[ $HOWMANYLINES -ge 1 ]]
  then
    cp $BFILETEMP $BPARSEDFILETEMP
  fi
fi

## Cheap error handling
if [[ -f $BFILETEMP ]]
then
  rm $BFILETEMP
fi
if [[ -f $BTEMPFILE ]]
then
  rm $BTEMPFILE
fi
