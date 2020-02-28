#!/bin/sh
## This script helps install the parser
##
## It checks if it's already installed
## and removes "old version" files
## It may spit out errors such as
## File does not exist
##
## It also sets the variable for the installation

## Install Variables
REPONAME=piholeparser
REPOOWNER=deathbybandaid
INSTALLPLACE=/etc/"$REPONAME"/

## Update
apt-get update

## Check for whiptail
if which whiptail >/dev/null;
then
  :
else
  apt-get install -y whiptail
fi

## Check for whiptail
if which git >/dev/null;
then
  :
else
  apt-get install -y git
fi

## Check for previous install
if [[ -d $INSTALLPLACE ]]
then
  PREVIOUSINSTALL=true
fi

## Remove Prior install
if [[ -n $PREVIOUSINSTALL ]]
then
  if (whiptail --title "$REPONAME" --yes-button "Remove beore install" --no-button "Abort" --yesno "$REPONAME is already installed?" 10 80)
  then
    rm -r /etc/"$REPONAME"
    rm /etc/updaterun"$REPONAME".sh
    crontab -l | grep -v 'bash /etc/"$REPONAME".sh'  | crontab -
  else
    exit
  fi
fi

## obvious question
if (whiptail --title ""$REPONAME"" --yes-button "yes" --no-button "no" --yesno "Do You want to install "$REPONAME"?" 10 80)
then
  git clone https://github.com/"$REPOOWNER"/"$REPONAME".git /etc/"$REPONAME"/
  cp /etc/"$REPONAME"/scripts/updaterun"$REPONAME".sh /etc/updaterun"$REPONAME".sh
  (crontab -l ; echo "20 0 * * * bash /updaterun"$REPONAME".sh") | crontab -
else
  exit
fi

## Save a pervious config?
if [[ -n $PREVIOUSINSTALL ]]
then
  if (whiptail --title ""$REPONAME"" --yes-button "keep config" --no-button "create new config" --yesno "Keep a previous config?" 10 80)
  then
    echo "keeping old config"
  else
    if [[-f /etc/"$REPONAME".var]]
    then
      rm /etc/"$REPONAME".var
    fi
    unset PREVIOUSINSTALL
  fi
fi

## What version?
if [[ -z $PREVIOUSINSTALL ]]
then
  if [[ ! -f /etc/"$REPONAME".var]]
  then
    cp /etc/"$REPONAME"/scriptvars/"$REPONAME".var /etc/"$REPONAME".var
  fi
  if (whiptail --title ""$REPONAME"" --yes-button "Local Only" --no-button "I'll be uploading to Github" --yesno "What Version of "$REPONAME" to install?" 10 80)
  then
    echo "version=local" | tee --append /etc/"$REPONAME".var
  else
    echo "version=github" | tee --append /etc/"$REPONAME".var
    GITHUBUSERNAME=$(whiptail --inputbox "Github Username" 10 80 "" 3>&1 1>&2 2>&3)
    GITHUBPASSWORD=$(whiptail --inputbox "Github Password" 10 80 "" 3>&1 1>&2 2>&3)
    GITHUBEMAIL=$(whiptail --inputbox "Github Email Address" 10 80 "" 3>&1 1>&2 2>&3)
    echo "GITHUBUSERNAME="$GITHUBUSERNAME"" | tee --append /etc/"$REPONAME".var
    echo "GITHUBPASSWORD="$GITHUBPASSWORD"" | tee --append /etc/"$REPONAME".var
    echo "GITHUBEMAIL="$GITHUBEMAIL"" | tee --append /etc/"$REPONAME".var
  fi
fi
