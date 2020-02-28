#!/bin/bash
##

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

## What type of source?
if [[ -z $FULLSKIPPARSING && -z $PINGTESTFAILED && $source == *.7z ]]
then
  SOURCETYPE=sevenzip
elif [[ -z $FULLSKIPPARSING && -z $PINGTESTFAILED && $source == *.tar.gz ]]
then
  SOURCETYPE=tar
elif [[ -z $FULLSKIPPARSING && -z $PINGTESTFAILED && $source == *.zip ]]
then
  SOURCETYPE=zip
elif [[ -z $FULLSKIPPARSING && -z $PINGTESTFAILED && $source == *.php ]]
then
  SOURCETYPE=php
elif [[ -z $FULLSKIPPARSING && -z $PINGTESTFAILED && $source == *.htm ]]
then
  SOURCETYPE=htm
elif [[ -z $FULLSKIPPARSING && -z $PINGTESTFAILED && $source == *.html ]]
then
  SOURCETYPE=html
elif [[ -z $FULLSKIPPARSING && -z $PINGTESTFAILED && $source == *.txt ]]
then
  SOURCETYPE=text
fi

## use mirror
if [[ -z $FULLSKIPPARSING && -n $PINGTESTFAILED && -f $CURRENTTLDLIST ]]
then
  SOURCETYPE=usemirrorfile
fi

## set the sourcetype if not
if [[ -z $FULLSKIPPARSING && -z $SOURCETYPE ]]
then
  SOURCETYPE=unknown
elif [[ -n $FULLSKIPPARSING && -z $SOURCETYPE ]]
then
  SOURCETYPE=skip
fi

## Add to tempvars
if [[ -z $FULLSKIPPARSING && -n $SOURCETYPE ]]
then
  echo "SOURCETYPE="$SOURCETYPE"" | tee --append $TEMPPARSEVARS &>/dev/null
fi

## Terminal Display
printf "$yellow"    "The Download Should use the $SOURCETYPE Preset."
timestamp=$(echo `date`)
if [[ -z $FULLSKIPPARSING && -n $SOURCEIP && -n $SOURCEDOMAIN && -n $SOURCETYPE ]]
then
  printf "$cyan"    "Fetching $SOURCETYPE List From $SOURCEDOMAIN Located At The IP address Of "$SOURCEIP"."
elif [[ -z $FULLSKIPPARSING && $SOURCETYPE == usemirrorfile ]]
then
  printf "$cyan"    "Attempting To Fetch List From Git Repo Mirror."
  echo "* $BASEFILENAME List Unavailable To Download. Attempted to use Mirror. $timestamp" | tee --append $RECENTRUN &>/dev/null
fi
