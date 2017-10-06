#!/bin/bash

_lib_git=1
printf "%s %s\n" "$(basename ${BASH_SOURCE[0]})" $_lib_git

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
