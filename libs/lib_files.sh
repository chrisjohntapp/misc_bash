#!/bin/bash
#
# Utility functions related to file operations.
#
# vi:syntax=sh
# shellcheck disable=SC2034
_LIB_FILES=1

function remove_file_end_strings() {
    # ====================================================================
    # Removes a string from the end of all filenames in a given directory.
    # ====================================================================
    OPTIND=1
    while getopts 'd:h' argv; do
        case "${argv}" in
            d) local target_dir="${OPTARG}" ;;
            h)
                printf "Usage: remove_file_end_strings [ -d <work "
                printf "directory> ] <string to remove>\n"
                return 1
                ;;
        esac
    done

    : ${target_dir:=$PWD}

    for _ in $(seq 2 "${OPTIND}"); do
        shift
    done

    if [[ -z "$1" ]]; then
        printf "No string supplied.\n"
        return 1
    else
        local end_string=$1
    fi

    local file
    find "${target_dir}" -type f -name "*${end_string}" -print0 | while \
        read -d $'\0' file; do mv "${file}" "${file%${end_string}}"; done
}

function tip() {
    # =========================================================================
    # Allows quick writing of cli notes/tips to a specific file within the tips
    # library. Alternatively prints the whole named file to stdout for reading,
    # or lists the contents of the tips library.
    # =========================================================================
    local -r tips_path='Dropbox/CLI_Tips'
    if [[ $# -gt 1 ]] && [[ -r "${HOME}/${tips_path}/${1}.txt" ]]; then
	local subject=$1; shift
	printf "%s\n" "$*" >> "${HOME}/${tips_path}/${subject}.txt"
    elif [[ $# -eq 1 ]]; then
	if [[ "$1" = '-l' ]]; then
	    ls "${HOME}/${tips_path}"
	else
	    local -r tip_file="${HOME}/${tips_path}/${1}.txt"
	    if [[ -r "${tip_file}" ]]; then
		less -F "${tip_file}"
	    else
		printf "%s%s\n" "Cannot find tip file: " "${tip_file}"
	    fi
	fi
    else
	printf "Usage: tip [ -l ] | [ subject (eg. 'mysql') ] [ Notes "
        printf "to add to file ]\n"
    fi
}

function tip_edit() {
    # =========================================================
    # Opens the named file within the tips library for editing.
    # =========================================================
    local -r tips_path='Dropbox/CLI_Tips'
    if [[ $# -eq 1 ]]; then
	local tip_file="${HOME}/${tips_path}/${1}.txt"
	if [[ -w "${tip_file}" ]]; then
	    vim "${tip_file}"
	else
	    printf "File does not exist for %s.\n" "$1"
	fi
    else
	printf "Usage: tip_edit subject\n"
    fi
}

function backup_file() {
    # ============================================================
    # Create a copy of a file, using a specific naming convention.
    # ============================================================
    if [[ -f "$1" ]]; then
	cp ./$1 ./${1}.$(date +%Y-%m-%d.%H%M.bak)
    fi
}

function find_younger_than() {
    # ===========================================================
    # Lists files under the given directory created less than the 
    # provided number of minutes ago.
    # ===========================================================
    if [[ $# -ne 2 ]]; then
        printf "Usage: find_younger_than minutes search_directory\n"
        return 1
    fi
    local mins=$1; local search_dir=$2 

    local search_date=$(date -d "-${mins} mins" +%Y%m%d%H%M)
    touch -t ${search_date} /tmp/find_younger_than-$$

    find ${search_dir} -type f -newer /tmp/find_younger_than-$$ \
      -print -exec ls -lt {} \;

    rm /tmp/find_younger_than-$$
}

