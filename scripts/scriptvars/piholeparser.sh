#!/bin/bash
# shellcheck disable=SC2034,SC2154
## This file contains the variables used in the setup

## Version Options control what the script does.
## Options are local or github
version=local

## Credentials if using Github
git_cred_user=""
git_cred_pass=""
git_cred_email=""

## Hosting locally
## Defaults
#LOCALHOSTDIR=/var/www/html/lists/
#CLOCALHOST="$BIGAPLLOCALHOSTDIR"CombinedBlackLists.txt
#DBBLOCALHOST="$BIGAPLLOCALHOSTDIR"DeathbybandaidList.txt

## Repo Information
## Repo
git_repo_name=piholeparser
git_repo_owner=deathbybandaid
git_repo_branch=master
git_repo_url_a="github.com/$git_repo_owner/$git_repo_name.git"
git_repo_url_b="https://github.com/$git_repo_owner/$git_repo_name.git"
git_repo_url_push="https://$git_cred_user:$git_cred_pass@$git_repo_url_a"
git_local_repo_path=/etc/"$git_repo_name"/

## Testing, without parsing
#FULLSKIPPARSING=true

## Force parse even when conditions would be otherwise
reparse_all=false
