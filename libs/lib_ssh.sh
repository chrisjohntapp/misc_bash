#!/bin/bash

# shellcheck disable=SC2034
_lib_ssh=1;

sshloop()
{
  # SSH to every host listed in <file> without checking host key, and
  # issue <command> on it.

  printf "\n!!! This command does very little sanity checking. Are you sure
you want to do this? Ctrl+C will cancel. You have 8 seconds.. !!!\n\n"
  sleep 8

  if [[ $# -ne 3 ]]; then
    printf "Usage: sshloop <file> <command> <sleep(secs)>\n"
    return 1
  fi

  local file=$1
  if ! [[ -r $file ]]; then
    printf "File is not readable.\n"
    return 1
  fi

  readarray hosts < $file

  local command=$2
  # Some sanity check here?

  local sleep=$3
  if ! [[ $sleep =~ ^-?[0-9]+$ ]]; then
    printf "Sleep must be an integer.\n"
    return 1
  fi

  for i in "${hosts[@]}"; do
    ssh -o StrictHostKeyChecking=no $i $command

#    if ! [[ $? = 0 ]]; then
#      printf "Failed while attempting to run \"$command\" on ${i}.\nExiting \
#for safety.\n"
#      return 1
#    fi

    sleep $sleep
  done
}

# vi:syntax=sh