#!/bin/bash

_lib_files=1
printf "%s %s\n" "$(basename ${BASH_SOURCE[0]})" $_lib_files

remove_file_endstrings()
{
  # Removes a string from the end of all filenames in a given directory. Probably
  # most suitable for removing file extensions.

  while getopts 'd:' argv; do
    case $argv in
      d) target_dir=$OPTARG ;;
      h) printf "Usage: remove_file_endstrings [ -d <work directory> ] <string to remove>\n" ;;
    esac
  done

  : ${target_dir:=$PWD}

  for _ in $(seq 2 $OPTIND); do
    shift
  done

  if [ -z "$1" ]; then
    printf "No string supplied."
    return 1
  else
    endstring=$1
  fi

  find $target_dir -type f -name "*${endstring}" -print0 | while read -d $'\0' file; do mv "$file" "${file%${endstring}}"; done

  unset target_dir endstring file
}

taketip()
{
  local tips_path='Dropbox/CLI_tips'
  if [ $# -gt 1 ]; then
    f=$1; shift
    printf "$*" >> ${HOME}/${tips_path}/${f}.txt
  elif [ $# -eq 1 ]; then
    cat ${HOME}/${tips_path}/${1}.txt
  else
    printf "Usage: taketip [ type ] [ Notes to add to file ]\n"
  fi
}

edittip()
{
  local tips_path='Dropbox/CLI_tips'
  if [ $# -eq 1 ]; then
    local filename=${HOME}/${tips_path}/${1}.txt
    if [ -w $filename ]; then
      vim $filename
    else
      printf "File does not exist.\n"
    fi
  else
    printf "Usage: edittip filename\n"
  fi
}

# vi:syntax=sh
