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
MIRROREDFILE="$MIRROREDWHITELISTSSUBDIR""$BASEFILENAME".txt
echo "MIRROREDFILE="$MIRROREDFILE"" | tee --append $TEMPPARSEVARS &>/dev/null

## Mirrored File (github)
MIRROREDFILEDL="$MIRROREDWHITELISTSSUBDIRGITRAW""$BASEFILENAME".txt
echo "MIRROREDFILEDL="$MIRROREDFILEDL"" | tee --append $TEMPPARSEVARS &>/dev/null

## Parsed File
PARSEDFILE="$PARSEDWHITELISTSSUBDIR""$BASEFILENAME".txt
echo "PARSEDFILE="$PARSEDFILE"" | tee --append $TEMPPARSEVARS &>/dev/null

## DeadList
WDEADPARSELIST="$DEADWHITELSTDIR""$BASEFILENAME".lst
echo "WDEADPARSELIST="$WDEADPARSELIST"" | tee --append $TEMPPARSEVARS &>/dev/null

## Un-DeadList
WUNDEADPARSELIST="$MAINWHITELSTSDIR""$BASEFILENAME".lst
echo "WUNDEADPARSELIST="$WUNDEADPARSELIST"" | tee --append $TEMPPARSEVARS &>/dev/null

## Kill The List
KILLTHELIST="$WHITELSTSTHATDIEDIR""$BASEFILENAME".list
echo "KILLTHELIST="$KILLTHELIST"" | tee --append $TEMPPARSEVARS &>/dev/null

## Temp Files
WTEMPFILE="$TEMPDIR""$WASEFILENAME".tempfile.txt
echo "WTEMPFILE="$WTEMPFILE"" | tee --append $TEMPPARSEVARS &>/dev/null
WFILETEMP="$TEMPDIR""$WASEFILENAME".filetemp.txt
echo "WFILETEMP="$WFILETEMP"" | tee --append $TEMPPARSEVARS &>/dev/null
WORIGINALFILETEMP="$TEMPDIR""$BASEFILENAME".original.txt
echo "WORIGINALFILETEMP="$WORIGINALFILETEMP"" | tee --append $TEMPPARSEVARS &>/dev/null
WPARSEDFILETEMP="$TEMPDIR""$BASEFILENAME".parsed.txt
echo "WPARSEDFILETEMP="$WPARSEDFILETEMP"" | tee --append $TEMPPARSEVARS &>/dev/null

## Terminal Display
printf "$yellow"    "$BASEFILENAME TempVars Have Been Set."
