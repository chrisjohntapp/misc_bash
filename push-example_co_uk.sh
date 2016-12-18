#!/bin/bash

# push-example.co.uk.sh -- <chrisjohntapp@gmail.com>

## SITE SPECIFIC VARS ####################################################
SUBDOMAIN="wwwstage"
DOMAIN="example.co.uk"
DOMAIN_ALIAS="examplecouk"
WP_EDIT_SCRIPT="wp-move-example.co.uk.sh"

## DYNAMIC VARS ##########################################################
BRANCH_NAME=$1
ITERATION=$2
PWD=$(pwd)
WORK_DIR=/var/www/sites/${DOMAIN}/stage/

## FUNCTIONS #############################################################
confirm () {
    read -r -p "${1:-Are you sure? [y/N]} " response
    case $response in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

rsync-uploads () {
    :
}

## CHECKS ################################################################
# Check sanity of inputs
[[ $# -eq 2 ]] || { echo "Usage: $0 <branch_name> <iteration>"; exit 1; }

# Ensure correct working directory
sleep 1 && [[ "${PWD}x" == "${WORK_DIR}x" ]] || { echo "Changing directory to $WORK_DIR"; cd $WORK_DIR; }

# Check worker scripts
sleep 1 && [[ -x "${WP_EDIT_SCRIPT}" ]] || { echo "${WP_EDIT_SCRIPT} does not exist or is not executable"; exit 2; }

# Are you sure?
sleep 1 && confirm "Have you exported posts and rsynced images from the live website into staging first?" || { echo "Push cancelled"; exit 3; }

## FILES STUFF ###########################################################
# Change wp-config stuff
sleep 1 && echo "Editing DB_NAME and DB_USER in wp-config.php to match live site"
sed -i "s/${DOMAIN_ALIAS}stage/${DOMAIN_ALIAS}/g" ${WORK_DIR}/wordpress/wp-config.php

## DATABASE STUFF ########################################################
# Run script to rename subdomain and dump database
sleep 1 && echo "Converting base URLs from ${SUBDOMAIN}, and creating a sql dump"
./${WP_EDIT_SCRIPT} || { echo 'Database convert and/or dump failed'; exit 4; }

## GIT STUFF #############################################################
# Check if new branch is required and create it if necessary
CURRENT_BRANCH=$(git branch | grep '*' | awk '{print $2}')

if [[ "${BRANCH_NAME}x" != "${CURRENT_BRANCH}x" ]]
then
    # Create new git branch and change to it
    sleep 1 && echo "Creating new git branch"
    git branch $BRANCH_NAME || { echo "Creation of new git branch $BRANCH_NAME failed"; exit 5; }

    sleep 1 && echo "Changing to new git branch"
    git checkout $BRANCH_NAME || { echo "Changing to new git branch failed"; exit 6; }

    # Push new branch to gerrit (without changes)
    sleep 1 && echo "Pushing new branch $BRANCH_NAME to gerrit"
    git push origin $BRANCH_NAME || { echo "Failed to push new branch $BRANCH_NAME to gerrit"; exit 7; }
fi

# Add any new files
sleep 1 && echo "Adding new files to git"
git add . || { echo "Failed to add new files to git"; exit 8; }

# Commit changes
sleep 1 && echo "Committing changes to local git repository"
git commit -a -m "${SUBDOMAIN}.${DOMAIN} $BRANCH_NAME $ITERATION" || { echo "Git commit failed"; exit 9; }

# Push to gerrit
sleep 1 && echo "Pushing new changes to gerrit"
git push origin HEAD:refs/for/${BRANCH_NAME} || { echo "Git push failed"; exit 10; }

## FINISH UP #############################################################
# Change wp-config stuff back
sleep 1 && echo "Editing DB_NAME and DB_USER in wp-config.php back to staging"
sed -i "s/${DOMAIN_ALIAS}/${DOMAIN_ALIAS}stage/g" ${WORK_DIR}/wordpress/wp-config.php

# Celebrate the news
sleep 1 && echo "Operations complete. Changes are in gerrit ready for review"

exit 0
