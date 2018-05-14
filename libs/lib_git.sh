#!/bin/bash
#
# Git utility functions.
#
# vi:syntax=sh
# shellcheck disable=SC2034
_LIB_GIT=1

function git_pull_all() {
    #########################################################################
    # cd's to each directory one level beneath the current working directory,
    # and if it is a git repo, issues 'git pull', and cd's back up a level.
    #########################################################################
    local func=$(basename "${FUNCNAME[0]}")

    local repo
    while IFS= read -r -d '' repo; do

	printf '%s\n' "${repo}"
	cd "${repo}" || { printf "cd to %s failed.\n" "${repo}"; return 1; }

	if [[ -d "./.git" ]]; then
	    git pull || { printf "git pull failed.\n"; return 1; }
	    cd .. || return 1
	else
	    printf "Does not appear to be a git repo. "
            printf "Continuing to next directory.\n"
	    cd .. || return 1
	fi

    done < <(find "${PWD}" -mindepth 1 -maxdepth 1 -type d -print0)
}
