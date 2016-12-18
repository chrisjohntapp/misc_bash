#!/bin/bash

# rotate-scans.sh -- <chrisjohntapp@gmail.com>

WORK_DIR=/home/public/scans
RETIRE_AGE=40320       # minutes
DIE_AGE=80640

TRASH_DIR=/${WORK_DIR}/.Trash

find ${WORK_DIR} -maxdepth 1 -type f -mmin +${RETIRE_AGE} -print0 | xargs -0 -r mv --target-directory=${TRASH_DIR}

find ${TRASH_DIR} -maxdepth 1 -type f -mmin +${DIE_AGE} -print0 | xargs -0 -r unlink

exit $?
