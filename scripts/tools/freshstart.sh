#!/bin/bash
##

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

#########################
## Clean Mirror Folder ##
#########################

echo "Cleaning Mirror Directory"
CHECKME=$MIRROREDBLACKLISTSSUBALL
if ls $CHECKME &> /dev/null;
then
  rm $CHECKME
fi
echo ""

#########################
## Clean Parsed Folder ##
#########################

echo "Cleaning Parsed Directory"
CHECKME=$PARSEDBLACKLISTSSUBALL
if ls $CHECKME &> /dev/null;
then
  rm $CHECKME
fi
echo ""

############################
## Clean ParsedALL Folder ##
############################

echo "Cleaning Parsedall Directory"
CHECKME=$COMBINEDBLACKLISTSSUBALL
if ls $CHECKME &> /dev/null;
then
  rm $CHECKME
fi
echo ""

############################
## Clean ParsedALL List   ##
############################

echo "Cleaning Parsedall List"
CHECKME=$COMBINEDBLACKLISTSSOURCE
if ls $CHECKME &> /dev/null;
then
  rm $CHECKME
fi
echo ""

#########################
## Country Codes Folder##
#########################

echo "Cleaning Country Codes Directory"
CHECKME=$COUNTRYCODESLISTSSUBALL
if
  ls $CHECKME &> /dev/null;
then
  rm $CHECKME
fi
echo ""


#########################
## Revert Killed Lists ##
#########################

echo "Reverting Killed Lists"
CHECKME=$BLACKLSTSTHATDIEALL
if
  ls $CHECKME &> /dev/null;
then
  for f in $BLACKLSTSTHATDIEALL
  do
    BASEFILENAME=$(echo `basename $f | cut -f 1 -d '.'`)
    BUNDEADPARSELIST="$MAINBLACKLSTSDIR""$BASEFILENAME".lst
    mv $f $BUNDEADPARSELIST
  done
fi
echo ""

#########################
## Revert Dead Lists ##
#########################

echo "Reverting Dead Lists"
CHECKME=$DEADBLACKLSTALL
if ls $CHECKME &> /dev/null;
then
  for f in $DEADBLACKLSTALL
  do
    BASEFILENAME=$(echo `basename $f | cut -f 1 -d '.'`)
    BUNDEADPARSELIST="$MAINBLACKLSTSDIR""$BASEFILENAME".lst
    mv $f $BUNDEADPARSELIST
  done
fi
echo ""

#####################
## Clean TLD Lists ##
#####################

echo "Cleaning TLD Lists"
CHECKME=$MIRROREDTLDLISTSSUBALL
if ls $CHECKME &> /dev/null;
then
  rm $CHECKME
fi

CHECKME=$TLDBKUP
if ls $CHECKME &> /dev/null;
then
  rm $CHECKME
fi
echo ""

###################
## Cleaning Temp ##
###################

echo "Cleaning Temp"
CHECKME=$TEMPCLEANUPONE
if ls $CHECKME &> /dev/null;
then
  rm $CHECKME
fi
CHECKME=$TEMPCLEANUPTWO
if ls $CHECKME &> /dev/null;
then
  rm $CHECKME
fi
CHECKME=$TEMPCLEANUPTHREE
if ls $CHECKME &> /dev/null;
then
  rm $CHECKME
fi

###################
## Cleaning Logs ##
###################

CHECKME=$CLEANRECENTRUNLOGSONE
if ls $CHECKME &> /dev/null;
then
  rm $CHECKME
fi
echo ""

CHECKME=$CLEANRECENTRUNLOGSTWO
if ls $CHECKME &> /dev/null;
then
  rm $CHECKME
fi
echo ""

CHECKME=$CLEANRECENTRUNLOGSTHREE
if ls $CHECKME &> /dev/null;
then
  rm $CHECKME
fi
echo ""

###############################
## Push Changes up to Github ##
###############################

timestamp=$(echo `date`)
WHYYOUDODIS=$(whiptail --inputbox "Why are you doing a manual push?" 10 80 " $timestamp" 3>&1 1>&2 2>&3)
echo "Pushing Lists to Github"
git -C $REPODIR pull
git -C $REPODIR remote set-url origin $GITWHERETOPUSH
git -C $REPODIR add .
git -C $REPODIR commit -m "$WHYYOUDODIS"
git -C $REPODIR push -u origin master
