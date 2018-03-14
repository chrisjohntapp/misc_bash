#!/bin/bash
#
# Utility functions related to apt/aptitude/apt-*/dpkg.
#
# vi:syntax=sh
# shellcheck disable=SC2034
_LIB_APT=1

function search_repo() {
    ##########################################################################
    # Print all packages contained within one or more configured repositories.
    ##########################################################################
    local func=$(basename "${FUNCNAME[0]}")

    if [[ $# != 1 ]]; then
	printf "Usage: %s <repo name glob>\n" "${func}"
	return 1
    fi

    . '/etc/os-release'
    if [[ "${ID_LIKE}" != 'debian' ]]; then
	printf "%s is for dpkg systems only.\n" "${func}"
	return 1
    fi

    if ! [[ -d '/var/lib/apt/lists' ]]; then
	printf "Could not find the package lists directory.\n"
	return 1
    fi

    cd '/var/lib/apt/lists' || return 1

    local -r repo_string=$1
    cat *${repo_string}* | grep '^Package: ' | sed 's/^Package: //' | sort -u
}

