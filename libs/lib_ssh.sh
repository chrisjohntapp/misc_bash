#!/bin/bash
#
# SSH utility functions.
#
# vi:syntax=sh
# shellcheck disable=SC2034
_LIB_SSH=1;

function ssh_loop() {
    #########################################################################
    # SSH to every host listed in <file> without checking host key, and issue
    # <command> on it.
    #########################################################################
    local func=$(basename "${FUNCNAME[0]}")

    if [[ $# -ne 3 ]]; then
        printf "Usage: %s file command sleep(secs)\n" "${func}"
        return 1
    fi

    printf "\nBeware, this command does very little sanity checking.\n"
    local response1
    read -r -p "Are you sure you want to proceed? [y/N]} " response1
    case "${response1}" in
	[yY][eE][sS]|[yY]) : ;;
        *) { printf "Operation cancelled.\n"; return 1; } ;;
    esac

    local -r file=$1
    if ! [[ -r "${file}" ]]; then
        printf "File is not readable.\n"
        return 1
    fi

    local command=$2

    declare -a sbins
    readarray sbins < <(find /sbin -printf "%f\n")

    for c in "${sbins[@]}"; do
        local stripc=${c%\\n}
        if [[ "${command}" = "$stripc" ]]; then
            printf "%s is a powerful command; do you really want " "{command}"
            printf "to do that on all those servers? "
            local response2 
            read -rp "[y/N]" response2
	    case "${response2}" in
		[yY][eE][sS]|[yY]) : ;;
		*) { printf "Operation cancelled.\n"; return 1; } ;;
	    esac
        fi
    done

    local sleep=$3
    if ! [[ ${sleep} =~ ^-?[0-9]+$ ]]; then
        printf "Sleep must be an integer.\n"
        return 1
    fi

    declare -a hosts
    readarray hosts < "${file}"

    for h in "${hosts[@]}"; do
        ssh -o StrictHostKeyChecking=no "$h" "${command}"

  #    if [[ $? != 0 ]]; then
  #      printf "Failed while attempting to run \"${command}\" on ${i}.\nExiting \
  #for safety.\n"
  #      return 1
  #    fi

        sleep ${sleep}
    done
}
