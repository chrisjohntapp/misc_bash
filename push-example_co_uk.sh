#!/bin/bash

## FUNCTIONS #############################################################
confirm()
{
  read -r -p "${1:-Are you sure? [y/N]} " response
  case $response in
    [yY][eE][sS]|[yY]) 
      true ;;
    *)
      false ;;
  esac
}

rsync-uploads()
{
  :
}

## INPUT VARS ############################################################
subdomain="wwwstage"
domain="example.co.uk"
domain_alias="examplecouk"
wp_edit_script="wp-move-example.co.uk.sh"

## DYNAMIC VARS ##########################################################
branch_name=$1
iteration=$2
work_dir=/var/www/sites/${domain}/stage/

## CHECKS ################################################################
# Check sanity of inputs
[[ $# -eq 2 ]] || { echo "Usage: $0 <branch_name> <iteration>"; exit 1; }

# Ensure correct working directory
sleep 1 && [ "$(pwd)x" = "${work_dir}x" ] || { echo "Changing directory to $work_dir"; cd $work_dir; }

# Check worker scripts
sleep 1 && [ -x "${wp_edit_script}" ] || { echo "${wp_edit_script} does not exist or is not executable"; exit 2; }

# Are you sure?
sleep 1 && confirm "Have you exported posts and rsynced images from the live website into staging first?" || { echo "Push cancelled"; exit 3; }

## FILES STUFF ###########################################################
# Change wp-config stuff
sleep 1 && echo "Editing DB_NAME and DB_USER in wp-config.php to match live site"
sed -i "s/${domain_alias}stage/${domain_alias}/g" ${work_dir}/wordpress/wp-config.php

## DATABASE STUFF ########################################################
# Run script to rename subdomain and dump database
sleep 1 && echo "Converting base URLs from ${subdomain}, and creating a sql dump"
./${wp_edit_script} || { echo 'Database convert and/or dump failed'; exit 4; }

## GIT STUFF #############################################################
# Check if new branch is required and create it if necessary
current_branch=$(git branch | grep '*' | awk '{print $2}')

if [[ "${branch_name}x" != "${current_branch}x" ]]
then
  # Create new git branch and change to it
  sleep 1 && echo "Creating new git branch"
  git branch $branch_name || { echo "Creation of new git branch $branch_name failed"; exit 5; }

  sleep 1 && echo "Changing to new git branch"
  git checkout $branch_name || { echo "Changing to new git branch failed"; exit 6; }

  # Push new branch to gerrit (without changes)
  sleep 1 && echo "Pushing new branch $branch_name to gerrit"
  git push origin $branch_name || { echo "Failed to push new branch $branch_name to gerrit"; exit 7; }
fi

# Add any new files
sleep 1 && echo "Adding new files to git"
git add . || { echo "Failed to add new files to git"; exit 8; }

# Commit changes
sleep 1 && echo "Committing changes to local git repository"
git commit -a -m "${subdomain}.${domain} $branch_name $iteration" || { echo "Git commit failed"; exit 9; }

# Push to gerrit
sleep 1 && echo "Pushing new changes to gerrit"
git push origin HEAD:refs/for/${branch_name} || { echo "Git push failed"; exit 10; }

## FINISH UP #############################################################
# Change wp-config stuff back.
sleep 1 && echo "Editing DB_NAME and DB_USER in wp-config.php back to staging."
sed -i "s/${domain_alias}/${domain_alias}stage/g" ${work_dir}/wordpress/wp-config.php

# Celebrate the news.
sleep 1 && echo "Operations complete. Changes are in gerrit ready for review."

# EOF
