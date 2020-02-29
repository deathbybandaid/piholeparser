#!/bin/bash
## This  just displays the source on screen

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.sh

printf "$yellow"    "$source"
