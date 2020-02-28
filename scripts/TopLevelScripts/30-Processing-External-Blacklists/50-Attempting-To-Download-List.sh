#!/bin/bash
## Attempt Download

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

## Terminal Display
if [[ -z $SKIPDOWNLOAD && $SOURCETYPE != usemirrorfile ]]
then
  printf "$yellow"    "Fetching $SOURCETYPE List From $SOURCEDOMAIN Located At The IP address Of "$SOURCEIP"."
fi

if [[ $SOURCETYPE == usemirrorfile ]]
then
  printf "$yellow"    "Using Existing Mirror File."
fi

## Logically download based on the Upcheck, and file type
if [[ $SOURCETYPE == unknown ]]
then
  wget -q -O $BTEMPFILE $source
elif [[ $SOURCETYPE == usemirrorfile ]]
then
  cat $MIRROREDFILE >> $BTEMPFILE
  USEDMIRRORFILE=true
  echo "USEDMIRRORFILE="$USEDMIRRORFILE"" | tee --append $TEMPPARSEVARS &>/dev/null
elif [[ $SOURCETYPE == localfile ]]
then
  curl -s -L $source >> $BTEMPFILE
elif [[ $SOURCETYPE == plaintext ]]
then
  wget -q --header="$AGENTDOWNLOAD" -O $BTEMPFILE $source
elif [[ $SOURCETYPE == webpage ]]
then
  curl -s -L -H "$AGENTDOWNLOAD" $source >> $BTEMPFILE
elif [[ $SOURCETYPE == zip ]]
then
  wget -q --header="$AGENTDOWNLOAD" -O $COMPRESSEDTEMPZIP $source
  7z e -so $COMPRESSEDTEMPZIP >> $BTEMPFILE
  rm $COMPRESSEDTEMPZIP
elif [[ $SOURCETYPE == seven ]]
then
  wget -q --header="$AGENTDOWNLOAD" -O $COMPRESSEDTEMPSEVEN $source
  7z e -so $COMPRESSEDTEMPSEVEN >> $BTEMPFILE
elif [[ $SOURCETYPE == tar ]]
then
  wget -q --header="$AGENTDOWNLOAD" -O $COMPRESSEDTEMPTAR $source
  TARFILEX=$(tar -xavf "$COMPRESSEDTEMPTAR" -C "$TEMPDIR")
  cat "$TEMPDIR""$TARFILEX" >> $BTEMPFILE
fi

## Check that there was a file downloaded
if [[ -f $BTEMPFILE ]]
then
  cat $BTEMPFILE >> $BORIGINALFILETEMP
  rm $BTEMPFILE
elif [[ ! -f $BTEMPFILE ]]
then
  printf "$red"    "File Download Failed."
  DOWNLOADFAILED=true
fi

## Try git Mirror
if [[ -n $DOWNLOADFAILED && -n $GITFILEONLINE ]]
then
  printf "$cyan"    "Attempting To Fetch List From Git Repo Mirror."
  echo "* $BASEFILENAME List Failed To Download. Attempted to use Mirror. $timestamp" | tee --append $RECENTRUN &>/dev/null
  wget -q -O $BTEMPFILE $MIRROREDFILEDL
  GITATTEMPTED=true
fi

## Check that there was a file downloaded
if [[ -n $DOWNLOADFAILED && -n $GITATTEMPTED && -f $BTEMPFILE ]]
then
  cat $BTEMPFILE >> $BORIGINALFILETEMP
  rm $BTEMPFILE
elif [[ -n $DOWNLOADFAILED && -n $GITATTEMPTED && ! -f $BTEMPFILE ]]
then
  printf "$red"    "Git Mirror Failed."
fi

## Check File
if [[ -f $BORIGINALFILETEMP ]]
then
  printf "$green"    "Download Successful."
elif [[ ! -f $BORIGINALFILETEMP ]]
then
  printf "$red"    "Download Failed."
  printf "$red"  "List Marked As Dead."
  mv $FILEBEINGPROCESSED $BDEADPARSELIST
fi
