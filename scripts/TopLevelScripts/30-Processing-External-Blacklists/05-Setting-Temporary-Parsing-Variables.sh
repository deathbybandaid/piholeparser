#!/bin/bash
## Phasing out DYNOVARS by claiming vars here

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

## Download URL
if [[ "$AMOUNTOFSOURCES" -le 1 ]]
then
  source="$(echo `cat $FILEBEINGPROCESSED`)"
elif [[ "$AMOUNTOFSOURCES" -gt 1 ]]
then
  source="$(echo `cat $FILEBEINGPROCESSED | head -1`)"
fi

echo "source='$source'" | tee --append $TEMPPARSEVARS &>/dev/null

## This extracts the domain from source
SOURCEDOMAIN=`echo $source | awk -F/ '{print $3}'`
echo "SOURCEDOMAIN="$SOURCEDOMAIN"" | tee --append $TEMPPARSEVARS &>/dev/null

## Mirrored File (local directory)
MIRROREDFILE="$MIRROREDBLACKLISTSSUBDIR""$BASEFILENAME".txt
echo "MIRROREDFILE="$MIRROREDFILE"" | tee --append $TEMPPARSEVARS &>/dev/null

## Mirrored File (github)
MIRROREDFILEDL="$MIRROREDBLACKLISTSSUBDIRGITRAW""$BASEFILENAME".txt
echo "MIRROREDFILEDL="$MIRROREDFILEDL"" | tee --append $TEMPPARSEVARS &>/dev/null

## Parsed File
PARSEDFILE="$PARSEDBLACKLISTSSUBDIR""$BASEFILENAME".txt
echo "PARSEDFILE="$PARSEDFILE"" | tee --append $TEMPPARSEVARS &>/dev/null

## DeadList
BDEADPARSELIST="$DEADBLACKLSTDIR""$BASEFILENAME".lst
echo "BDEADPARSELIST="$BDEADPARSELIST"" | tee --append $TEMPPARSEVARS &>/dev/null

## Un-DeadList
BUNDEADPARSELIST="$MAINBLACKLSTSDIR""$BASEFILENAME".lst
echo "BUNDEADPARSELIST="$BUNDEADPARSELIST"" | tee --append $TEMPPARSEVARS &>/dev/null

## Kill The List
KILLTHELIST="$BLACKLSTSTHATDIEDIR""$BASEFILENAME".list
echo "KILLTHELIST="$KILLTHELIST"" | tee --append $TEMPPARSEVARS &>/dev/null

## Temp Files
BTEMPFILE="$TEMPDIR""$BASEFILENAME".tempfile.txt
echo "BTEMPFILE="$BTEMPFILE"" | tee --append $TEMPPARSEVARS &>/dev/null
BFILETEMP="$TEMPDIR""$BASEFILENAME".filetemp.txt
echo "BFILETEMP="$BFILETEMP"" | tee --append $TEMPPARSEVARS &>/dev/null
BORIGINALFILETEMP="$TEMPDIR""$BASEFILENAME".original.txt
echo "BORIGINALFILETEMP="$BORIGINALFILETEMP"" | tee --append $TEMPPARSEVARS &>/dev/null
BPARSEDFILETEMP="$TEMPDIR""$BASEFILENAME".parsed.txt
echo "BPARSEDFILETEMP="$BPARSEDFILETEMP"" | tee --append $TEMPPARSEVARS &>/dev/null

## Terminal Display
printf "$yellow"    "$BASEFILENAME TempVars Have Been Set."
