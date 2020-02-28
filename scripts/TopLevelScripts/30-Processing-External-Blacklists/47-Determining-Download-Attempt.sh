#!/bin/bash
## How should we download

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

## What type of source?
if [[ -z $SKIPDOWNLOAD && $source == *.7z ]]
then
  SOURCETYPE=sevenzip
elif [[ -z $SKIPDOWNLOAD && $source == *.tar.gz ]]
then
  SOURCETYPE=tar
elif [[ -z $SKIPDOWNLOAD && $source == *.zip ]]
then
  SOURCETYPE=zip
elif [[ -z $SKIPDOWNLOAD && $source == "file:///"* ]]
then
  SOURCETYPE=localfile
elif [[ -z $SKIPDOWNLOAD && $source == *"?"* ]]
then
  SOURCETYPE=webpage
elif [[ -z $SKIPDOWNLOAD && $source == *"="* ]]
then
  SOURCETYPE=webpage
elif [[ -z $SKIPDOWNLOAD && $source == *.php ]]
then
  SOURCETYPE=webpage
elif [[ -z $SKIPDOWNLOAD && $source == *.htm ]]
then
  SOURCETYPE=webpage
elif [[ -z $SKIPDOWNLOAD && $source == *.html ]]
then
  SOURCETYPE=webpage
elif [[ -z $SKIPDOWNLOAD && $source == *.txt ]]
then
  SOURCETYPE=plaintext
elif [[ -z $SKIPDOWNLOAD && $source == *.csv ]]
then
  SOURCETYPE=plaintext
elif [[ -z $SKIPDOWNLOAD && $source == *hosts ]]
then
  SOURCETYPE=plaintext
fi

## use mirror
if [[ -n $SKIPDOWNLOAD ]]
then
  SOURCETYPE=usemirrorfile
fi

## set the sourcetype if not
if [[ -z $SOURCETYPE ]]
then
  SOURCETYPE=unknown
fi

if [[ -n $SOURCETYPE ]]
then
  printf "$yellow"    "The Download Should use the $SOURCETYPE Preset."
  echo "SOURCETYPE="$SOURCETYPE"" | tee --append $TEMPPARSEVARS &>/dev/null
fi
