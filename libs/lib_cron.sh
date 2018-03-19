#!/bin/bash
#
# Utility functions related to cron.
#
# vi:syntax=sh
# shellcheck disable=SC2034
_LIB_CRON=1

function run_as_cron() {
    ##################################################
    # Run a command using only environment variables set in <env_file>. Used
    # primarily to test things run from cron, by first creating an env_file
    # by entering '* * * * * env > ~/cron_env' into a crontab.
    ##################################################
    local func=$(basename "${FUNCNAME[0]}")

    [[ $# = 2 ]] || \
        { printf "Usage: %s env_file command\n" "${func}"; return 1; }

    /usr/bin/env -i /bin/bash -c ". $1; $2"
}

