#!/bin/bash
## This should help me find what parsed list contains a domain

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

if [[ ! -f $COMBINEDBLACKLISTS ]]
then
  printf "$red"  "Big Black List File Missing."
  touch $COMBINEDBLACKLISTS
fi

## Check if white list is present
if [[ ! -f $COMBINEDWHITELISTS ]]
then
  printf "$red"  "Big White List File Missing."
  touch $COMBINEDWHITELISTS
fi

DOMAINTOLOOKFOR=$(whiptail --inputbox "What Domain Whould be Whitelisted?" 10 80 "" 3>&1 1>&2 2>&3)

BLACKHOWMANYLINES=$(echo -e "`wc -l $COMBINEDBLACKLISTS | cut -d " " -f 1`")
echo "Black file is $BLACKHOWMANYLINES lines"
WHITEHOWMANYLINES=$(echo -e "`wc -l $COMBINEDWHITELISTS | cut -d " " -f 1`")
echo "White file is $WHITEHOWMANYLINES lines"
if grep -q $DOMAINTOLOOKFOR "$COMBINEDBLACKLISTS"
then
  echo "Found on Big BlackList"
else
  echo "Not Found on Big BlackList"
fi
if grep -q $DOMAINTOLOOKFOR "$COMBINEDWHITELISTS"
then
  echo "Found on Big WhiteList"
else
  echo "Not Found on Big WhiteList"
fi

echo " "
if grep -q $DOMAINTOLOOKFOR "$COMBINEDWHITELISTS" && grep -q $DOMAINTOLOOKFOR "$COMBINEDBLACKLISTS"
then
  echo "Found on Both Lists"

  echo ""
  echo "Using Method comm"
  comm -23 $COMBINEDBLACKLISTS $COMBINEDWHITELISTS > $FILETEMP
  METHODHOWMANYLINES=$(echo -e "`wc -l $FILETEMP | cut -d " " -f 1`")
  echo "new file is $METHODHOWMANYLINES lines"
  if grep -q -Fx $DOMAINTOLOOKFOR "$FILETEMP"
  then
    echo "$DOMAINTOLOOKFOR in file."
  else
    echo "$DOMAINTOLOOKFOR not in file."
  fi
  rm $FILETEMP
  echo ""

  echo "Using Method gawk"
  gawk 'NR==FNR{a[$0];next} !($0 in a)' $COMBINEDWHITELISTS $COMBINEDBLACKLISTS >> $FILETEMP
  METHODHOWMANYLINES=$(echo -e "`wc -l $FILETEMP | cut -d " " -f 1`")
  echo "new file is $METHODHOWMANYLINES lines"
  if grep -q $DOMAINTOLOOKFOR "$FILETEMP"
  then
    echo "$DOMAINTOLOOKFOR in file."
  else
    echo "$DOMAINTOLOOKFOR not in file."
  fi
  rm $FILETEMP
  echo ""

  echo "Using Method grep"
  grep -Fvxf $COMBINEDWHITELISTS $COMBINEDBLACKLISTS >> $FILETEMP
  METHODHOWMANYLINES=$(echo -e "`wc -l $FILETEMP | cut -d " " -f 1`")
  echo "new file is $METHODHOWMANYLINES lines"
  if grep -q $DOMAINTOLOOKFOR "$FILETEMP"
  then
    echo "$DOMAINTOLOOKFOR in file."
  else
    echo "$DOMAINTOLOOKFOR not in file."
  fi
  rm $FILETEMP
  echo ""
  
  echo "Using Method diff"
  diff --unchanged-line-format="" --old-line-format="%L" --new-line-format="" $COMBINEDBLACKLISTS $COMBINEDWHITELISTS > $FILETEMP
  METHODHOWMANYLINES=$(echo -e "`wc -l $FILETEMP | cut -d " " -f 1`")
  echo "new file is $METHODHOWMANYLINES lines"
  if grep -q $DOMAINTOLOOKFOR "$FILETEMP"
  then
    echo "$DOMAINTOLOOKFOR in file."
  else
    echo "$DOMAINTOLOOKFOR not in file."
  fi
  rm $FILETEMP
  echo ""
  
  echo "Using Method join"
  join -v 2 <(sort $COMBINEDWHITELISTS) <(sort $COMBINEDBLACKLISTS) > $FILETEMP
  METHODHOWMANYLINES=$(echo -e "`wc -l $FILETEMP | cut -d " " -f 1`")
  echo "new file is $METHODHOWMANYLINES lines"
  if grep -q $DOMAINTOLOOKFOR "$FILETEMP"
  then
    echo "$DOMAINTOLOOKFOR in file."
  else
    echo "$DOMAINTOLOOKFOR not in file."
  fi
  rm $FILETEMP
  echo ""
  
  echo "Using Method sort"
  sort $COMBINEDWHITELISTS $COMBINEDBLACKLISTS | uniq -u >> $FILETEMP
  METHODHOWMANYLINES=$(echo -e "`wc -l $FILETEMP | cut -d " " -f 1`")
  echo "new file is $METHODHOWMANYLINES lines"
  if grep -q $DOMAINTOLOOKFOR "$FILETEMP"
  then
    echo "$DOMAINTOLOOKFOR in file."
  else
    echo "$DOMAINTOLOOKFOR not in file."
  fi
  rm $FILETEMP
  echo ""
  
  echo "Using Method fgrep"
  fgrep -v -f $COMBINEDWHITELISTS $COMBINEDBLACKLISTS > $FILETEMP
  METHODHOWMANYLINES=$(echo -e "`wc -l $FILETEMP | cut -d " " -f 1`")
  echo "new file is $METHODHOWMANYLINES lines"
  if grep -q $DOMAINTOLOOKFOR "$FILETEMP"
  then
    echo "$DOMAINTOLOOKFOR in file."
  else
    echo "$DOMAINTOLOOKFOR not in file."
  fi
  rm $FILETEMP
  echo ""
  
  
  #echo "Using Method loop"
  #cat $COMBINEDBLACKLISTS | while read line1
  #do
  #  cat $COMBINEDWHITELISTS | while read line2
  #  do
  #    if [[ $line1 == $line2 ]]
  #    then
  #      echo $line1 >>$FILETEMP
  #    fi
  #  done
  #done
  #METHODHOWMANYLINES=$(echo -e "`wc -l $FILETEMP | cut -d " " -f 1`")
  #echo "new file is $METHODHOWMANYLINES lines"
  #if grep -q $DOMAINTOLOOKFOR "$FILETEMP"
  #then
  #  echo "$DOMAINTOLOOKFOR in file."
  #else
  #  echo "$DOMAINTOLOOKFOR not in file."
  #fi
  #rm $FILETEMP
  #echo ""

else
  echo "Not Found on Both Lists"
fi

