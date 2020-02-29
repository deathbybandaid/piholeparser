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
git_repo_name=piholeparser
git_repo_owner=deathbybandaid
git_repo_branch=master
git_repo_url_a="github.com/"$git_repo_owner"/"$git_repo_name".git"
git_repo_url_b="https://github.com/"$git_repo_owner"/"$git_repo_name".git"
git_local_repo_path=/etc/"$git_repo_name"/
OUTSIDEDIRVARS=/etc/"$git_repo_name".var
update_config_file="$COMMONSCRIPTSDIR"Update-Config-File.sh

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
if [[ -d $git_local_repo_path ]]
then
  PREVIOUSINSTALL=true
fi

## Remove Prior install
if [[ -n $PREVIOUSINSTALL ]]
then
  if (whiptail --title "$git_repo_name" --yes-button "Remove beore install" --no-button "Abort" --yesno "$git_repo_name is already installed?" 10 80)
  then
    rm -r /etc/"$git_repo_name"
    rm /etc/updaterun"$git_repo_name".sh
    crontab -l | grep -v 'bash /etc/"$git_repo_name".sh'  | crontab -
  else
    exit
  fi
fi

## obvious question
if (whiptail --title ""$git_repo_name"" --yes-button "yes" --no-button "no" --yesno "Do You want to install "$git_repo_name"?" 10 80)
then
  git clone https://github.com/"$git_repo_owner"/"$git_repo_name".git /etc/"$git_repo_name"/
  cp /etc/"$git_repo_name"/scripts/updaterun"$git_repo_name".sh /etc/updaterun"$git_repo_name".sh
  (crontab -l ; echo "20 0 * * * bash /updaterun"$git_repo_name".sh") | crontab -
else
  exit
fi

## Save a pervious config?
if [[ -n $PREVIOUSINSTALL ]]
then
  if (whiptail --title ""$git_repo_name"" --yes-button "keep config" --no-button "create new config" --yesno "Keep a previous config?" 10 80)
  then
    echo "keeping old config"
  else
    if [[ -f "$OUTSIDEDIRVARS" ]]
    then
      rm "$OUTSIDEDIRVARS"
    fi
    unset PREVIOUSINSTALL
  fi
fi

## What version?
if [[ -z $PREVIOUSINSTALL ]]
then
  if [[ ! -f "$OUTSIDEDIRVARS"]]
  then
    cp /etc/"$git_repo_name"/scripts/scriptvars/"$OUTSIDEDIRVARS" "$OUTSIDEDIRVARS"
  fi
  if (whiptail --title ""$git_repo_name"" --yes-button "Local Only" --no-button "I'll be uploading to Github" --yesno "What Version of "$git_repo_name" to install?" 10 80)
  then
    #echo "version=local" | tee --append "$OUTSIDEDIRVARS"
    bash update_config_file version local
  else
    #echo "version=github" | tee --append "$OUTSIDEDIRVARS"
    bash update_config_file version github
    git_cred_user=$(whiptail --inputbox "Github Username" 10 80 "" 3>&1 1>&2 2>&3)
    git_cred_pass=$(whiptail --inputbox "Github Password" 10 80 "" 3>&1 1>&2 2>&3)
    git_cred_email=$(whiptail --inputbox "Github Email Address" 10 80 "" 3>&1 1>&2 2>&3)
    #echo "git_cred_user="$git_cred_user"" | tee --append "$OUTSIDEDIRVARS"
    #echo "git_cred_pass="$git_cred_pass"" | tee --append "$OUTSIDEDIRVARS"
    #echo "git_cred_email="$git_cred_email"" | tee --append "$OUTSIDEDIRVARS"
    bash update_config_file git_cred_user $git_cred_user
    bash update_config_file git_cred_pass $git_cred_pass
    bash update_config_file git_cred_email $git_cred_email
  fi
fi
