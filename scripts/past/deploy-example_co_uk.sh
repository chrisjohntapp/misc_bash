#!/bin/bash

# deploy-example_co_uk.sh

#===== SITE SPECIFIC VARS ================================================================
WORKDIR=/var/www/vhosts/example_co_uk/
DBNAME=examplecouk
DBUSER=examplecouk
DBPASS=Umd93aNd8Zds
DBDUMPFILE=${WORKDIR}/dbdump-examplecouk.sql
WEBSITE="www.example.co.uk"
APACHE_USER=examplecouk

#===== DYNAMIC VARS ======================================================================
PWD=$(pwd)
DATE=$(date '+%F')
BRANCHNAME=$1

#===== FUNCTIONS =========================================================================
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

warn () {
    echo "The script failed at some point between making $WORKDIR mutable and making it immutable again. Please make directory tree immutable manually"
}

#===== CHECKS ============================================================================
# Check sanity of inputs
[[ $# -eq 1 ]] || { echo "Usage: $0 <branch_name>"; exit 1; }

# Ensure correct working directory
sleep 1 && [[ "${PWD}x" == "${WORKDIR}x" ]] || { echo "Changing directory to ${WORKDIR}"; cd ${WORKDIR}; }

# Check repository is current
sleep 1 && STATUS=$(git status)

[[ ${STATUS} == *modified* ]] && { echo "Repository contents have changed since last deploy -- please commit or revert any changes then run this script again"; exit 2; }

# Final sanity check
confirm "You are about to deploy a new live version of ${WEBSITE}. Are you sure?" || { echo "Deploy cancelled"; exit 3; }

# Make directory tree mutable
sleep 1 && echo "Making ${WORKDIR}/wordpress directory tree mutable"

find ${WORKDIR}/wordpress -print -exec chattr -i {} \; || { echo "Failed to make ${WORKDIR}/wordpress dir tree mutable"; exit 4; }

find ${WORKDIR}/themes -print -exec chattr -i {} \; || { echo "Failed to make ${WORKDIR}/themes dir tree mutable"; exit 5; }

#===== GIT STUFF ========================================================================
# Perform git fetch
git fetch origin || { echo "Git fetch failed"; warn; exit 6; }

# Check out the new branch if required
CURRENTBRANCH=$(git branch | grep '*' | awk '{print $2}')

sleep 1 && echo "Checking if we need to checkout the git branch"

if [[ "${BRANCHNAME}x" != "${CURRENTBRANCH}x" ]]
then
    sleep 1 && echo "We do. Now to checkout the new branch"
    git checkout -b ${BRANCHNAME} || { echo "Git checkout failed"; warn; exit 7; }
else
    sleep 1 && echo "Nope. Already on correct branch"
fi                                        

# Git pull
git pull origin ${BRANCHNAME} || { echo "Git pull failed"; warn; exit 8; } 

#===== DATABASE STUFF ===================================================================
# Take backup of the current database
sleep 1 && echo "Backing up the current database"

mysqldump -u ${DBUSER} -p${DBPASS} ${DBNAME} > /tmp/${DBNAME}-${DATE} || { echo "Database dump failed"; warn; exit 9; }

gzip /tmp/${DBNAME}-${DATE}

# Import new database dump file to live database
sleep 1 && echo "Now importing the database dump file"

mysql -u ${DBUSER} -p${DBPASS} ${DBNAME} < ${DBDUMPFILE} || { echo "Database import failed"; warn; exit 10; }

#===== FINISH UP ========================================================================
# Make wordpress directory tree immutable
sleep 1 && echo "Making ${WORKDIR}/wordpress directory tree immutable"  

find ${WORKDIR}/wordpress -path ${WORKDIR}/wordpress/wp-content/uploads -prune -o -print -exec chattr +i {} \; || { echo "Failed to make ${WORKDIR}/wordpress dir tree immutable"; exit 11; }

find ${WORKDIR}/themes -print -exec chattr +i {} \; || { echo "Failed to make ${WORKDIR}/themes dir tree immutable"; exit 12; }

# Change file ownership for any new files
sleep 1 && echo "Changing file ownership of any new files"

chown -R ${APACHE_USER}.${APACHE_USER} ${WORKDIR}/wordpress

# Celebrate the news                                                                              
sleep 2 && echo "Deploy complete -- check ${WEBSITE}. If there are any problems roll back using 'git checkout <previous_branch>' and restore the database from /tmp/${DBNAME}-${DATE}.gz"
                                                                                                                                        
exit 0
