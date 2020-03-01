#!/bin/bash
# shellcheck disable=SC1090,SC2034,SC2154

## This creates my custom biglist

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.sh

WHATITIS="All Parsed List (edited without porn)"
timestamp=$(echo "`date`")
if [[ -f $COMBINEDBLACKLISTSDBBWOPORN ]]
then
  rm $COMBINEDBLACKLISTSDBBWOPORN
  echo "* $WHATITIS Removed. $timestamp" | tee --append $RECENTRUN &>/dev/null
else
  echo "* $WHATITIS Not Removed. $timestamp" | tee --append $RECENTRUN &>/dev/null
fi

if [[ ! -f $COMBINEDBLACKLISTSDBB ]]
then
  printf "$red"  "Big Black List File Missing."
  touch $COMBINEDBLACKLISTSDBB
fi


printf "$cyan"  "Generating All Parsed List (edited without porn)."
echo ""

## Remove Porn Domains
printf "$yellow"  "Removing porn domains Domains."
cp $COMBINEDBLACKLISTSDBB $FILETEMP

if ls $BLACKLSTALL &> /dev/null;
then

  for f in $BLACKLSTALL
  do
    BASEFILENAME=$(echo "`basename $f | cut -f 1 -d '.'`")
    BASEFILENAME_LOWER=$(echo "$BASEFILENAME" | sed -e 's/\(.*\)/\L\1/')
    if [[ $BASEFILENAME_LOWER == *"porn"* ]]
    then
      comm -23 $FILETEMP $f > $TEMPFILE
      rm $FILETEMP
      mv $TEMPFILE $FILETEMP
      echo -e "`wc -l $FILETEMP | cut -d " " -f 1` lines after removing from $BASEFILENAME"
      echo ""
    fi
  done
fi

echo -e "`wc -l $FILETEMP | cut -d " " -f 1` lines after removing porn domains"
echo ""

if [[ -f $FILETEMP ]]
then
  EDITEDALLPARSEDSIZEBYTES=$(stat -c%s "$FILETEMP")
  EDITEDALLPARSEDSIZEKB=`expr $EDITEDALLPARSEDSIZEBYTES / 1024`
  EDITEDALLPARSEDSIZEMB=`expr $EDITEDALLPARSEDSIZEBYTES / 1024 / 1024`
  echo "EDITEDALLPARSEDSIZEMB=$EDITEDALLPARSEDSIZEMB" | tee --append $TEMPVARS &>/dev/null
fi

if [[ "$EDITEDALLPARSEDSIZEMB" -gt 0 && "$EDITEDALLPARSEDSIZEKB" -gt 0 && "$EDITEDALLPARSEDSIZEBYTES" -gt 0 ]]
then
  printf "$yellow"  "Size of $BASEFILENAME = $EDITEDALLPARSEDSIZEMB MB."
elif [[ "$EDITEDALLPARSEDSIZEMB" -eq 0 && "$EDITEDALLPARSEDSIZEKB" -gt 0 && "$EDITEDALLPARSEDSIZEBYTES" -gt 0 ]]
then
  printf "$yellow"  "Size of $BASEFILENAME = $EDITEDALLPARSEDSIZEKB KB."
elif [[ "$EDITEDALLPARSEDSIZEMB" -eq 0 && "$EDITEDALLPARSEDSIZEKB" -eq 0 && "$EDITEDALLPARSEDSIZEBYTES" -gt 0 ]]
then
  printf "$yellow"  "Size of List = $EDITEDALLPARSEDSIZEBYTES Bytes."
fi

if [[ "$EDITEDALLPARSEDSIZEBYTES" -gt 0 ]]
then
  EDITEDALLPARSEDHOWMANYLINES=$(echo -e "`wc -l $FILETEMP | cut -d " " -f 1`")
  printf "$yellow"  "$EDITEDALLPARSEDHOWMANYLINES Lines After Compiling."
  echo "EDITEDALLPARSEDHOWMANYLINES=$EDITEDALLPARSEDHOWMANYLINES" | tee --append $TEMPVARS &>/dev/null
fi

if [[ -f $COMBINEDBLACKLISTSDBBWOPORN && "$EDITEDALLPARSEDSIZEBYTES" -gt 0 ]]
then
  printf "$green"  "Old COMBINEDBLACKLISTSDBBWOPORN File Removed."
  rm $COMBINEDBLACKLISTSDBBWOPORN
fi

## Github has a 100mb limit, and empty files are useless
if  [[ "$EDITEDALLPARSEDSIZEBYTES" -eq 0 ]]
then
  printf "$red"     "File Empty"
  echo "* Allparsedlist list was an empty file $timestamp" | tee --append $RECENTRUN &>/dev/null
  mv $FILETEMP $COMBINEDBLACKLISTSDBBWOPORN
elif [[ "$EDITEDALLPARSEDSIZEMB" -ge "$GITHUBLIMITMB" ]]
then
  printf "$red"     "Parsed File Too Large For Github. Deleting."
  rm $FILETEMP
  touch $COMBINEDBLACKLISTSDBBWOPORN
  echo "* Allparsedlist list was too large to host on github. $EDITEDALLPARSEDSIZEMB bytes $timestamp" | tee --append $RECENTRUN &>/dev/null
elif [[ "$EDITEDALLPARSEDSIZEMB" -lt "$GITHUBLIMITMB" && -f $FILETEMP ]]
then
  mv $FILETEMP $COMBINEDBLACKLISTSDBBWOPORN
  printf "$yellow"  "Big List Edited Without Porn Created Successfully."
fi
