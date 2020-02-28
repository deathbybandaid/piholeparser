#!/bin/bash
## Valid Domains

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

printf "$yellow"  "This Process Normally Takes Longer Than The Others."

for source in `cat $BFILETEMP`;
do

if ping -c 1 -W 1 $source &> /dev/null
then
echo "$source" | tee --append $BTEMPFILE &>/dev/null
fi

done

if
[[ -f $BFILETEMP ]]
then
rm $BFILETEMP
fi
