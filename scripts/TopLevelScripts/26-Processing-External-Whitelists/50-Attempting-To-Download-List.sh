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
  wget -q -O $WTEMPFILE $source
elif [[ $SOURCETYPE == usemirrorfile ]]
then
  cat $MIRROREDFILE >> $WTEMPFILE
  USEDMIRRORFILE=true
  echo "USEDMIRRORFILE="$USEDMIRRORFILE"" | tee --append $TEMPPARSEVARS &>/dev/null
elif [[ $SOURCETYPE == localfile ]]
then
  curl -s -L $source >> $WTEMPFILE
elif [[ $SOURCETYPE == plaintext ]]
then
  wget -q --header="$AGENTDOWNLOAD" -O $WTEMPFILE $source
elif [[ $SOURCETYPE == webpage ]]
then
  curl -s -L -H "$AGENTDOWNLOAD" $source >> $WTEMPFILE
elif [[ $SOURCETYPE == zip ]]
then
  wget -q --header="$AGENTDOWNLOAD" -O $COMPRESSEDTEMPZIP $source
  7z e -so $COMPRESSEDTEMPZIP >> $WTEMPFILE
  rm $COMPRESSEDTEMPZIP
elif [[ $SOURCETYPE == seven ]]
then
  wget -q --header="$AGENTDOWNLOAD" -O $COMPRESSEDTEMPSEVEN $source
  7z e -so $COMPRESSEDTEMPSEVEN >> $WTEMPFILE
elif [[ $SOURCETYPE == tar ]]
then
  wget -q --header="$AGENTDOWNLOAD" -O $COMPRESSEDTEMPTAR $source
  TARFILEX=$(tar -xavf "$COMPRESSEDTEMPTAR" -C "$TEMPDIR")
  cat "$TEMPDIR""$TARFILEX" >> $WTEMPFILE
fi

## Check that there was a file downloaded
if [[ -f $WTEMPFILE ]]
then
  cat $WTEMPFILE >> $WORIGINALFILETEMP
  rm $WTEMPFILE
elif [[ ! -f $WTEMPFILE ]]
then
  printf "$red"    "File Download Failed."
  DOWNLOADFAILED=true
fi

## Try git Mirror
if [[ -n $DOWNLOADFAILED && -n $GITFILEONLINE ]]
then
  printf "$cyan"    "Attempting To Fetch List From Git Repo Mirror."
  echo "* $BASEFILENAME List Failed To Download. Attempted to use Mirror. $timestamp" | tee --append $RECENTRUN &>/dev/null
  wget -q -O $WTEMPFILE $MIRROREDFILEDL
  GITATTEMPTED=true
fi

## Check that there was a file downloaded
if [[ -n $DOWNLOADFAILED && -n $GITATTEMPTED && -f $WTEMPFILE ]]
then
  cat $WTEMPFILE >> $WORIGINALFILETEMP
  rm $WTEMPFILE
elif [[ -n $DOWNLOADFAILED && -n $GITATTEMPTED && ! -f $WTEMPFILE ]]
then
  printf "$red"    "Git Mirror Failed."
fi

## Check File
if [[ -f $WORIGINALFILETEMP ]]
then
  printf "$green"    "Download Successful."
elif [[ ! -f $WORIGINALFILETEMP ]]
then
  printf "$red"    "Download Failed."
  printf "$red"  "List Marked As Dead."
  mv $FILEBEINGPROCESSED $WDEADPARSELIST
fi
