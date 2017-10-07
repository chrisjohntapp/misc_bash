#!/bin/bash
#
# Git utility functions.
#
# vi:syntax=sh
# shellcheck disable=SC2034
_LIB_GIT=1

function pull_all() {
  ##############################################################################
  # cd's to each directory one level beneath the current working directory, and
  # if it is a git repo, issues 'git pull', and cd's back up a level.
  # Globals:
  #   None
  # Arguments:
  #   None
  # Returns:
  #   None
  ##############################################################################
  local repo
  while IFS= read -r -d '' repo; do

    printf '%s\n' "${repo}"
    cd "${repo}" || { printf "cd'ing to ${repo} failed.\n"; return 1; }

    if [[ -d "./.git" ]]; then
      git pull || { printf "git pull failed.\n"; return 1; }
      cd ..
    else
      printf "Does not appear to be a git repo. Continuing to next directory.\n"
      cd ..
    fi

  done < <(find "${PWD}" -mindepth -maxdepth 1 -type d -print0)
}
