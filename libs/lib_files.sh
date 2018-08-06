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
    local func=$(basename "${FUNCNAME[0]}")

    OPTIND=1
    while getopts 'd:h' argv; do
        case "${argv}" in
            d) local target_dir="${OPTARG}" ;;
            h)
                printf "Usage: %s [ -d <work " "${func}"
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
    local func=$(basename "${FUNCNAME[0]}")

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
		cat "${tip_file}"
	    else
		printf "Cannot find tip file: %s\n" "${tip_file}"
	    fi
	fi
    else
	printf "Usage: %s [ -l ] | [ subject (eg. 'mysql') ] " "${func}"
        printf "[ Notes to add to file ]\n"
    fi
}

function tip_edit() {
    # =========================================================
    # Opens the named file within the tips library for editing.
    # =========================================================
    local func=$(basename "${FUNCNAME[0]}")

    local -r tips_path='Dropbox/CLI_Tips'
    if [[ $# -eq 1 ]]; then
	local tip_file="${HOME}/${tips_path}/${1}.txt"
	if [[ -w "${tip_file}" ]]; then
	    vim "${tip_file}"
	else
	    printf "No tip file exists for %s.\n" "$1"
	fi
    else
	printf "Usage: %s subject\n" "${func}"
    fi
}

function backup_file() {
    # ============================================================
    # Create a copy of a file, using a specific naming convention.
    # ============================================================
    local func=$(basename "${FUNCNAME[0]}")

    if [[ -f "$1" ]]; then
	cp ./$1 ./${1}.$(date +%Y-%m-%d.%H%M.bak)
    fi
}

function find_younger_than() {
    # ===========================================================
    # Lists files under the given directory created less than the
    # provided number of minutes ago.
    # ===========================================================
    local func=$(basename "${FUNCNAME[0]}")

    if [[ $# -ne 2 ]]; then
        printf "Usage: %s minutes search_directory\n" "${func}"
        return 1
    fi
    local mins=$1; local search_dir=$2 

    local search_date=$(date -d "-${mins} mins" +%Y%m%d%H%M)
    touch -t ${search_date} /tmp/${func}-$$

    find ${search_dir} -type f -newer /tmp/${func}-$$ -print -exec ls -lt {} \;

    rm /tmp/${func}-$$
}

function trash() {
    # ===========================================================
    # Move file/dir to ${HOME}/.Trash (rather than rm'ing it).
    # ===========================================================
    local func=$(basename "${FUNCNAME[0]}")

    [[ $# -eq 1 ]] || { printf "Usage: %s file|dir\n"; return 1; }

    local target="$1"

    mv $target ~/.Trash || { printf "Could not trash ${target}\n"; return 1; }
}

function yml_to_yaml() {
    # ===========================================================
    # Rename every file extension under $PWD from .yml to .yaml, by default.
    # Can also take two arguments to replace those values.
    # ===========================================================
    local func=$(basename "${FUNCNAME[0]}")

    if [[ $# -ne 2 ]] && [[ $# -ne 0 ]]; then
        printf "Usage: %s || %s old_ext new_ext (don't include the dot)\n" "${func}"
        return 1
    fi

    old_ext=${1:-yml}
    new_ext=${2:-yaml}
    
    while read -r -d ''; do
        file=${REPLY%.${old_ext}}
        mv "${REPLY}" "${file}.${new_ext}"
    done < <(find ${PWD} -type f -name "*.${old_ext}" -print0)
}

