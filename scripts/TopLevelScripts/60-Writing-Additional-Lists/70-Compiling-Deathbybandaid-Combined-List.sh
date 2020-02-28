#!/bin/bash
## This creates my custom biglist

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

WHATITIS="All Parsed List (edited)"
timestamp=$(echo `date`)
if [[ -f $COMBINEDBLACKLISTSDBB ]]
then
  rm $COMBINEDBLACKLISTSDBB
  echo "* $WHATITIS Removed. $timestamp" | tee --append $RECENTRUN &>/dev/null
else
  echo "* $WHATITIS Not Removed. $timestamp" | tee --append $RECENTRUN &>/dev/null
fi

if [[ ! -f $COMBINEDBLACKLISTS ]]
then
  printf "$red"  "Big Black List File Missing."
  touch $COMBINEDBLACKLISTS
fi

## Check if white list is present
if [[ ! -f $COMBINEDWHITELISTS ]]
then
  printf "$red"  "Big White List File Missing."
  touch $COMBINEDWHITELISTS
fi

printf "$cyan"  "Generating All Parsed List (edited)."
echo ""

## Remove Whitelist Domains
if [[ -f $COMBINEDWHITELISTS  ]]
then
  printf "$yellow"  "Removing whitelist Domains."
  cp $COMBINEDBLACKLISTS $FILETEMP

  ## gawk
  #gawk 'NR==FNR{a[$0];next} !($0 in a)' $COMBINEDWHITELISTS $FILETEMP >> $TEMPFILE
  #rm $FILETEMP
  #mv $TEMPFILE $FILETEMP

  ## grep
  #grep -Fvxf $COMBINEDWHITELISTS $FILETEMP >> $TEMPFILE
  #rm $FILETEMP
  #mv $TEMPFILE $FILETEMP

  ## comm
  comm -23 $FILETEMP $COMBINEDWHITELISTS > $TEMPFILE
  rm $FILETEMP
  mv $TEMPFILE $FILETEMP

  ## diff
  #diff -a --suppress-common-lines -y --speed-large-files $FILETEMP $COMBINEDWHITELISTS | grep "<" | sed 's/^<//g'  > $TEMPFILE
  #rm $FILETEMP
  #mv $TEMPFILE $FILETEMP

  ## Join
  #join -v 2 <(sort $COMBINEDWHITELISTS) <(sort $FILETEMP) > $TEMPFILE
  #rm $FILETEMP
  #mv $TEMPFILE $FILETEMP

  ## fgrep
  #fgrep -v -f $COMBINEDWHITELISTS $FILETEMP > $TEMPFILE
  #rm $FILETEMP
  #mv $TEMPFILE $FILETEMP


  echo -e "`wc -l $FILETEMP | cut -d " " -f 1` lines after whitelist"
  echo ""
fi

if [[ -f $FILETEMP ]]
then
  EDITEDALLPARSEDSIZEBYTES=$(stat -c%s "$FILETEMP")
  EDITEDALLPARSEDSIZEKB=`expr $EDITEDALLPARSEDSIZEBYTES / 1024`
  EDITEDALLPARSEDSIZEMB=`expr $EDITEDALLPARSEDSIZEBYTES / 1024 / 1024`
  echo "EDITEDALLPARSEDSIZEMB="$EDITEDALLPARSEDSIZEMB"" | tee --append $TEMPVARS &>/dev/null
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
  echo "EDITEDALLPARSEDHOWMANYLINES="$EDITEDALLPARSEDHOWMANYLINES"" | tee --append $TEMPVARS &>/dev/null
fi

if [[ -f $COMBINEDBLACKLISTSDBB && "$EDITEDALLPARSEDSIZEBYTES" -gt 0 ]]
then
  printf "$green"  "Old COMBINEDBLACKLISTSDBB File Removed."
  rm $COMBINEDBLACKLISTSDBB
fi

## Github has a 100mb limit, and empty files are useless
if  [[ "$EDITEDALLPARSEDSIZEBYTES" -eq 0 ]]
then
  printf "$red"     "File Empty"
  echo "* Allparsedlist list was an empty file $timestamp" | tee --append $RECENTRUN &>/dev/null
  mv $FILETEMP $COMBINEDBLACKLISTSDBB
elif [[ "$EDITEDALLPARSEDSIZEMB" -ge "$GITHUBLIMITMB" ]]
then
  printf "$red"     "Parsed File Too Large For Github. Deleting."
  rm $FILETEMP
  touch $COMBINEDBLACKLISTSDBB
  echo "* Allparsedlist list was too large to host on github. $EDITEDALLPARSEDSIZEMB bytes $timestamp" | tee --append $RECENTRUN &>/dev/null
elif [[ "$EDITEDALLPARSEDSIZEMB" -lt "$GITHUBLIMITMB" && -f $FILETEMP ]]
then
  mv $FILETEMP $COMBINEDBLACKLISTSDBB
  printf "$yellow"  "Big List Edited Created Successfully."
fi
