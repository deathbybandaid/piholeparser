#!/bin/bash
## This creates my custom biglist

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

WHATITIS="All Parsed List (edited)"
timestamp=$(echo `date`)
if [[ -f $COMBINEDWHITELISTSDBB ]]
then
  rm $COMBINEDWHITELISTSDBB
  echo "* $WHATITIS Removed. $timestamp" | tee --append $RECENTRUN &>/dev/null
else
  echo "* $WHATITIS Not Removed. $timestamp" | tee --append $RECENTRUN &>/dev/null
fi

if [[ ! -f $WHITELISTTEMP ]]
then
  printf "$red"  "Whitelist File Missing."
  MISSINGWHITE=true
fi
if [[ ! -f $WHITELISTTEMP ]]
then
  printf "$red"  "Whitelist File Missing."
  MISSINGWHITE=true
fi
if [[ ! -f $COMBINEDWHITELISTS ]]
then
  printf "$red"  "Big List File Missing."
  touch $COMBINEDWHITELISTS
fi

printf "$cyan"  "Generating All Parsed List (edited)."
echo ""

## Add Whitelist Domains
if [[ -z $MISSINGWHITE ]]
then
  printf "$yellow"  "Adding WHITElist Domains."
  cat $WHITELISTTEMP $COMBINEDWHITELISTS >> $FILETEMP
  echo -e "`wc -l $FILETEMP | cut -d " " -f 1` lines after whitelist"
  echo ""
else
  cp $COMBINEDWHITELISTS $FILETEMP
fi

## Dedupe
printf "$yellow"  "Removing Duplicate Whitelist Entries."
cat -s $FILETEMP | sort -u | gawk '{if (++dup[$0] == 1) print $0;}' >> $TEMPFILE
echo -e "`wc -l $TEMPFILE | cut -d " " -f 1` lines after deduping"
rm $FILETEMP
echo ""

## Remove Whitelist Domains
if [[ -z $MISSINGWHITE ]]
then
  printf "$yellow"  "Removing whitelist Domains."
  gawk 'NR==FNR{a[$0];next} !($0 in a)' $WHITELISTTEMP $TEMPFILE >> $FILETEMP
  #grep -Fvxf $WHITELISTTEMP $TEMPFILE >> $FILETEMP
  rm $TEMPFILE
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

if [[ -f $COMBINEDWHITELISTSDBB && "$EDITEDALLPARSEDSIZEBYTES" -gt 0 ]]
then
  printf "$green"  "Old COMBINEDWHITELISTSDBB File Removed."
  rm $COMBINEDWHITELISTSDBB
fi

## Github has a 100mb limit, and empty files are useless
if  [[ "$EDITEDALLPARSEDSIZEBYTES" -eq 0 ]]
then
  printf "$red"     "File Empty"
  echo "* Allparsedlist list was an empty file $timestamp" | tee --append $RECENTRUN &>/dev/null
  mv $FILETEMP $COMBINEDWHITELISTSDBB
elif [[ "$EDITEDALLPARSEDSIZEMB" -ge "$GITHUBLIMITMB" ]]
then
  printf "$red"     "Parsed File Too Large For Github. Deleting."
  rm $FILETEMP
  touch $COMBINEDWHITELISTSDBB
  echo "* Allparsedlist list was too large to host on github. $EDITEDALLPARSEDSIZEMB bytes $timestamp" | tee --append $RECENTRUN &>/dev/null
elif [[ "$EDITEDALLPARSEDSIZEMB" -lt "$GITHUBLIMITMB" && -f $FILETEMP ]]
then
  mv $FILETEMP $COMBINEDWHITELISTSDBB
  printf "$yellow"  "Big List Edited Created Successfully."
fi
