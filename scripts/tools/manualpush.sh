#!/bin/bash
## This script pushes lists to Github manually

## Variables
SCRIPTDIRA=$(dirname $0)
source "$SCRIPTDIRA"/foldervars.var

## Push Changes up to Github
timestamp=$(echo `date`)
WHYYOUDODIS=$(whiptail --inputbox "Why are you doing a manual push?" 10 80 "Change Made Offline $timestamp" 3>&1 1>&2 2>&3)
printf "$green"   "Pushing Lists to Github"
git -C $git_local_repo_path pull
git -C $git_local_repo_path remote set-url origin $git_repo_url_push
git -C $git_local_repo_path add .
git -C $git_local_repo_path commit -m "$WHYYOUDODIS"
git -C $git_local_repo_path push -u origin $git_repo_branch
