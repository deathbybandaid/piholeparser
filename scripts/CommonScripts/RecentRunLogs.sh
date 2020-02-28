#!/bin/bash
## This Recreates Recent Run Log

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

SCRIPTTEXT="Creating Main Recent Run Log."
timestamp=$(echo `date`)

echo "## $SCRIPTTEXT $timestamp" | tee --append $TEMPLOGMAIN &>/dev/null

CHECKME=$RECENTRUNLOGSDIRCLEAN
if ls $CHECKME &> /dev/null;
then
  rm -rf $CHECKME
fi
echo ""

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

if [[ -f $MAINRECENTRUNLOGMD ]]
then
  echo "* Old Recent Run Log Purged." | tee --append $TEMPLOGMAIN &>/dev/null
  rm $MAINRECENTRUNLOGMD
fi

if [[ -f $TEMPLOGMAIN ]]
then
  echo "* Recent Run Log Recreated." | tee --append $TEMPLOGMAIN &>/dev/null
  mv $TEMPLOGMAIN $MAINRECENTRUNLOGMD
fi

CHECKME=$TOPLEVELSCRIPTSLOGSDIR
if ls $CHECKME &> /dev/null;
then
  :
else
  mkdir $CHECKME
fi
echo ""
