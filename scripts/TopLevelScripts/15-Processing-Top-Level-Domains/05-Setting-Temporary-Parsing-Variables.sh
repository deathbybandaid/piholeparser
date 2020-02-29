#!/bin/bash
# shellcheck disable=SC1090,SC2034,SC2154
##

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.sh

## Download URL
source="$(echo "`cat $FILEBEINGPROCESSED`")"
echo "source=$source" | tee --append $TEMPPARSEVARS &>/dev/null

## This extracts the domain from source
SOURCEDOMAIN=`echo $source | awk -F/ '{print $3}'`
echo "SOURCEDOMAIN=$SOURCEDOMAIN" | tee --append $TEMPPARSEVARS &>/dev/null

## Local List
CURRENTTLDLIST=$MIRROREDTLDLISTSSUBDIR$BASEFILENAME.txt
echo "CURRENTTLDLIST=$CURRENTTLDLIST" | tee --append $TEMPPARSEVARS &>/dev/null

## Temps
BTEMPFILE=$TEMPDIR$BASEFILENAME.tempfile.txt
echo "BTEMPFILE=$BTEMPFILE" | tee --append $TEMPPARSEVARS &>/dev/null
BFILETEMP=$TEMPDIR$BASEFILENAME.filetemp.txt
echo "BFILETEMP="$BFILETEMP | tee --append $TEMPPARSEVARS &>/dev/null
BORIGINALFILETEMP="$TEMPDIR""$BASEFILENAME".original.txt
echo "BORIGINALFILETEMP=$BORIGINALFILETEMP" | tee --append $TEMPPARSEVARS &>/dev/null
