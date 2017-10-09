#!/bin/bash
#
# Utility functions related to apt/aptitude/apt-*/dpkg.
#
# vi:syntax=sh
# shellcheck disable=SC2034
_LIB_APT=1

function search_repo() {
  ##############################################################################
  # Print all packages contained within one or more configured repositories.
  ##############################################################################

  if [[ $# != 1 ]]; then
    printf "%s %s %s\n" "Usage:" "$(basename "${FUNCNAME[0]}")" "'repo name glob'"
    return 1
  fi

  . '/etc/os-release'
  if [[ "${ID_LIKE}" != 'debian' ]]; then
    printf "$(basename "${FUNCNAME[0]}") is for dpkg systems only.\n"
    return 1
  fi

  if ! [[ -d '/var/lib/apt/lists' ]]; then
    printf "Could not find the package lists directory.\n"
    return 1
  fi
  cd '/var/lib/apt/lists' || return 1

  local -r REPO_STRING=$1
  cat "*${REPO_STRING}*" | grep '^Package: ' | sed 's/^Package: //' | sort -u
}
