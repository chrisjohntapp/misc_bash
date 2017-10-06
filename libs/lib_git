#!/bin/bash
_lib_git=1
printf "%s %s\n" "$(basename ${BASH_SOURCE[0]})" $_lib_git

pull-all()
{
  for _ in *; do ls -ld $i; cd $i; git pull; cd ..; done
}

# vi:syntax=sh
