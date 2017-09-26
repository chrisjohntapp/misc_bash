#!/bin/bash

# git-snapshot-example_co.sh
# To be run from cron

#==================================================================================================

WORKDIR=/var/www/vhosts/example_co
LOG_FILE=/var/log/messages
LOG_PREFIX="$(date '+%b  %e %X')  $0 --"

#==================================================================================================

TIMESTAMP=$(date '+%F-%H-%M')

[[ "$(pwd)x" == "${WORKDIR}x" ]] || cd $WORKDIR

CHANGE_STATUS=$(git status | grep -v branch)

git branch $TIMESTAMP || { echo "${LOG_PREFIX} git branch failed" >> ${LOG_FILE}; exit 1; }

git checkout $TIMESTAMP || { echo "${LOG_PREFIX} git checkout failed" >> ${LOG_FILE}; exit 2; }

if [[ ! "$CHANGE_STATUS" =~ "nothing to commit" ]]
then
    git add . || { echo "${LOG_PREFIX} git add failed" >> ${LOG_FILE}; exit 3; }
    git commit -a -m "Changes up to $TIMESTAMP committed" || { echo "${LOG_PREFIX} git commit failed" >> ${LOG_FILE}; exit 4; }
fi
 
echo "${LOG_PREFIX} success!" >> $LOG_FILE

exit 0
