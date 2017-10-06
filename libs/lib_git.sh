#!/bin/bash

# shellcheck disable=SC2034
_lib_git=1

pull-all()
{
  for i in *; do
    ls -ld $i
    cd $i || { printf "cd'ing to $i failed.\n"; return 1; }
    git pull || { printf "git pull failed.\n"; return 1; }
    cd ..
  done
}

# vi:syntax=sh
