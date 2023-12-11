#!/bin/bash
#
# Splunky stuff.
#
# vi:syntax=sh
# shellcheck disable=SC2034
_LIB_SPLUNK=1;

create_stack() {
    ##################################################
    # Create stack (dev or stg) with configurable ttl.
    ##################################################
    local func=$(basename "${FUNCNAME[0]}")

    [[ $# -eq 3 ]] || { printf "Usage: %s <stack name> \"<ticket reason>\" <ttl (days)>\n" "${func}"; return 1; }

    local datetime=$(date -Iseconds)
    local futuredate=$(date -Iseconds -v +${3}d)
    datetime=${datetime%T*}
    futuredate=${futuredate%T*}

    cloudctl stacks create $1 -f ${1}.yml --reason "${2}"
    sleep 5
    cloudctl stacks ttl update ${1} "${futuredate}T19:00:00Z" "${2}"
    sleep 5

    result=$(cloudctl stacks proposals list ${1})
    readarray -t aresult <<< "${result}"
    for i in "${aresult[@]}"; do
        if [[ ${i} =~ "id: " ]]; then
	    proposalid=${i:3}
	    sleep 2
	fi
    done

    sleep 5
    cloudctl stacks proposals approve ${1} ${proposalid}
}
