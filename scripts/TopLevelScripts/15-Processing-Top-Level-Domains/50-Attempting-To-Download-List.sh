#!/bin/bash
##

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

## FULLSKIPPARSING text
if [[ -n $FULLSKIPPARSING ]]
then
  printf "$yellow"    "Not Downloading List."
fi

## Logically download based on the Upcheck, and file type
if [[ -z $FULLSKIPPARSING && $SOURCETYPE == unknown ]]
then
  wget -q -O $BTEMPFILE $source
elif [[ -z $FULLSKIPPARSING && $SOURCETYPE == text ]]
then
  wget -q -O $BTEMPFILE $source
elif [[ -z $FULLSKIPPARSING && $SOURCETYPE == php ]]
then
  curl -s -L $source >> $BTEMPFILE
elif [[ -z $FULLSKIPPARSING && $SOURCETYPE == htm ]]
then
  curl -s -L $source >> $BTEMPFILE
elif [[ -z $FULLSKIPPARSING && $SOURCETYPE == html ]]
then
  curl -s -L $source >> $BTEMPFILE
elif [[ -z $FULLSKIPPARSING && $SOURCETYPE == usemirrorfile ]]
then
  cat $CURRENTTLDLIST >> $BTEMPFILE
  USEDMIRRORFILE=true
  echo "USEDMIRRORFILE="$USEDMIRRORFILE"" | tee --append $TEMPPARSEVARS &>/dev/null
elif [[ -z $FULLSKIPPARSING && $SOURCETYPE == zip ]]
then
  wget -q -O $COMPRESSEDTEMPZIP $source
  7z e -so $COMPRESSEDTEMPZIP > $BTEMPFILE
  rm $COMPRESSEDTEMPZIP
elif [[ -z $FULLSKIPPARSING && $SOURCETYPE == seven ]]
then
  wget -q -O $COMPRESSEDTEMPSEVEN $source
  7z e -so $COMPRESSEDTEMPSEVEN > $BTEMPFILE
elif [[ -z $FULLSKIPPARSING && $SOURCETYPE == tar ]]
then
  wget -q -O $COMPRESSEDTEMPTAR $source
  TARFILEX=$(tar -xavf "$COMPRESSEDTEMPTAR" -C "$TEMPDIR")
  mv "$TEMPDIR""$TARFILEX" $BTEMPFILE
fi

## Check If File Was Downloaded
if [[ -z $FULLSKIPPARSING && -f $BTEMPFILE ]]
then
  cat $BTEMPFILE >> $BORIGINALFILETEMP
  rm $BTEMPFILE
elif [[ -z $FULLSKIPPARSING && ! -f $BTEMPFILE ]]
then
  printf "$red"    "File Download Failed."
  DOWNLOADFAILED=true
  touch $BORIGINALFILETEMP
fi

## Check that there was a file downloaded
## Try as a browser
if [[ -z $FULLSKIPPARSING && -f $BORIGINALFILETEMP ]]
then
  FETCHFILESIZE=$(stat -c%s "$BORIGINALFILETEMP")
  FETCHFILESIZEMB=`expr $FETCHFILESIZE / 1024 / 1024`
  timestamp=$(echo `date`)
fi
if [[ -z $FULLSKIPPARSING && "$FETCHFILESIZE" -gt 0 ]]
then
  printf "$green"    "Download Successful."
elif [[ -z $FULLSKIPPARSING && "$FETCHFILESIZE" -le 0 ]]
then
  printf "$red"    "Download Failed."
  DOWNLOADFAILED=true
  touch $BORIGINALFILETEMP
fi

## Attempt agent download
if  [[ -z $FULLSKIPPARSING && -n $DOWNLOADFAILED && "$FETCHFILESIZE" -eq 0 && $source != *.7z && $source != *.tar.gz && $source != *.zip ]]
then
  echo ""
  printf "$cyan"    "Attempting To Fetch List As if we were a browser."
  curl -s -H "$AGENTDOWNLOAD" -L $source >> $BTEMPFILE
  cat $BTEMPFILE >> $BORIGINALFILETEMP
  rm $BTEMPFILE
fi
