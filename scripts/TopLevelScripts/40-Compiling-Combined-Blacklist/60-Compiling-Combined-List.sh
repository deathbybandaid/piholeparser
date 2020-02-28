#!/bin/bash
## This takes the work done in parser
## and merges it all into one

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

WHATITIS="All Parsed List"
timestamp=$(echo `date`)
if [[ -f $COMBINEDBLACKLISTS ]]
then
  rm $COMBINEDBLACKLISTS
  echo "* $WHATITIS Removed. $timestamp" | tee --append $RECENTRUN &>/dev/null
else
  echo "* $WHATITIS Not Removed. $timestamp" | tee --append $RECENTRUN &>/dev/null
fi

if [[ ! -f $BLACKLISTTEMP ]]
then
  printf "$red"  "Blacklist File Missing."
  MISSINGBLACK=true
fi

## Combine Small lists
printf "$yellow"  "Merging Individual Lists."
if ls $PARSEDBLACKLISTSSUBALL &> /dev/null;
then
  cat $PARSEDBLACKLISTSSUBALL >> $TEMPFILE
  echo -e "`wc -l $TEMPFILE | cut -d " " -f 1` lines after merging individual lists"
else
  printf "$red"  "No Parsed Files Available To Merge."
  touch $TEMPFILE
  INDIVIDUALMERGEFAILED=true
fi
echo ""

## Add Script.domains
if [[ -z $MISSINGBLACK ]]
then
  printf "$yellow"  "Adding Blacklist Domains."
  cat $BLACKLISTTEMP $TEMPFILE >> $FILETEMP
  rm $TEMPFILE
  echo -e "`wc -l $FILETEMP | cut -d " " -f 1` lines after blacklist"
  echo ""
else
  cp $COMBINEDBLACKLISTS $FILETEMP
fi

## Duplicate Removal
if [[ -f $FILETEMP ]]
then
  printf "$yellow"  "Removing duplicates."
  cat -s $FILETEMP | sort -u | gawk '{if (++dup[$0] == 1) print $0;}' >> $TEMPFILE
  echo -e "`wc -l $TEMPFILE | cut -d " " -f 1` lines after deduping"
  rm $FILETEMP
  echo ""
fi

if [[ -f $TEMPFILE ]]
then
  ALLPARSEDSIZEBYTES=$(stat -c%s "$TEMPFILE")
  ALLPARSEDSIZEKB=`expr $ALLPARSEDSIZEBYTES / 1024`
  ALLPARSEDSIZEMB=`expr $ALLPARSEDSIZEBYTES / 1024 / 1024`
  echo "ALLPARSEDSIZEMB="$ALLPARSEDSIZEMB"" | tee --append $TEMPVARS &>/dev/null
fi

if [[ "$ALLPARSEDSIZEMB" -gt 0 && "$ALLPARSEDSIZEKB" -gt 0 && "$ALLPARSEDSIZEBYTES" -gt 0 ]]
then
  printf "$yellow"  "Size of $BASEFILENAME = $ALLPARSEDSIZEMB MB."
elif [[ "$ALLPARSEDSIZEMB" -eq 0 && "$ALLPARSEDSIZEKB" -gt 0 && "$ALLPARSEDSIZEBYTES" -gt 0 ]]
then
  printf "$yellow"  "Size of $BASEFILENAME = $ALLPARSEDSIZEKB KB."
elif [[ "$ALLPARSEDSIZEMB" -eq 0 && "$ALLPARSEDSIZEKB" -eq 0 && "$ALLPARSEDSIZEBYTES" -gt 0 ]]
then
  printf "$yellow"  "Size of List = $ALLPARSEDSIZEBYTES Bytes."
fi

if [[ "$ALLPARSEDSIZEBYTES" -gt 0 ]]
then
  PARSEDHOWMANYLINES=$(echo -e "`wc -l $TEMPFILE | cut -d " " -f 1`")
  printf "$yellow"  "$PARSEDHOWMANYLINES Lines After Compiling."
fi

if [[ -f $COMBINEDBLACKLISTS && "$ALLPARSEDSIZEBYTES" -gt 0 ]]
then
  printf "$green"  "Old COMBINEDBLACKLISTS File Removed."
  rm $PARSEDFILE
fi

## Github has a 100mb limit, and empty files are useless
if  [[ "$ALLPARSEDSIZEBYTES" -eq 0 ]]
then
  printf "$red"     "File Empty"
  echo "* Allparsedlist list was an empty file $timestamp" | tee --append $RECENTRUN &>/dev/null
  mv $TEMPFILE $COMBINEDBLACKLISTS
elif [[ "$ALLPARSEDSIZEMB" -ge "$GITHUBLIMITMB" ]]
then
  printf "$red"     "Parsed File Too Large For Github. Deleting."
  echo "* Allparsedlist list was too large to host on github. $FETCHFILESIZE bytes $timestamp" | tee --append $RECENTRUN &>/dev/null
  mv $TEMPFILE $COMBINEDBLACKLISTS
elif [[ "$ALLPARSEDSIZEMB" -lt "$GITHUBLIMITMB" && -f $TEMPFILE ]]
then
  mv $TEMPFILE $COMBINEDBLACKLISTS
  printf "$yellow"  "Big List Created Successfully."
fi
