#!/bin/bash
# shellcheck disable=SC1090,SC2034,SC2154

## This  just displays the source on screen

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.sh

printf "$yellow"    "$source"
