#!/bin/bash
_lib_apt=1
printf "%s %s\n" "$(basename ${BASH_SOURCE[0]})" $_lib_apt

search_repo()
{
  . /etc/os-release

  if [ ! $# = 1 ]; then
    printf "Usage: $(basename $0) <repo name substring>.\n"
    return 1
  fi

  if [ "$ID_LIKE" != "debian" ]; then
    printf "$(basename $0) is for dpkg systems only.\n"
    return 1
  fi

  if [ ! -r /var/lib/apt/lists ]; then
    printf "Could not read the package lists file.\n"
    return 1
  fi

  cd /var/lib/apt/lists && cat *$1* | grep "^Package: " | sed 's/^Package: //' | sort -u
}

# vi:syntax=sh
