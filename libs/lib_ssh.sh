#!/bin/bash
#
# SSH utility functions.
#
# vi:syntax=sh
# shellcheck disable=SC2034
_LIB_SSH=1;

function ssh_loop() {
  ##############################################################################
  # SSH to every host listed in <file> without checking host key, and issue
  # <command> on it.
  ##############################################################################
  printf "\nBeware; this command does very little sanity checking.\n"
  local response
  read -r -p "Are you sure you want to proceed? [y/N]} " response
  case "${response}" in
    [yY][eE][sS]|[yY]) : ;;
                    *) { printf "Operation cancelled.\n"; return 1; } ;;
  esac

  if [[ $# -ne 3 ]]; then
    printf "Usage: sshloop <file> <command> <sleep(secs)>\n"
    return 1
  fi

  local -r FILE=$1
  if ! [[ -r "${FILE}" ]]; then
    printf "File is not readable.\n"
    return 1
  fi

  readarray hosts < "${FILE}"

  local command=$2
  # TODO: Insert some sanity check here?

  local sleep=$3
  if ! [[ ${sleep} =~ ^-?[0-9]+$ ]]; then
    printf "Sleep must be an integer.\n"
    return 1
  fi

  for i in "${hosts[@]}"; do
    ssh -o StrictHostKeyChecking=no "${i}" "${command}"

#    if [[ $? != 0 ]]; then
#      printf "Failed while attempting to run \"${command}\" on ${i}.\nExiting \
#for safety.\n"
#      return 1
#    fi

    sleep ${sleep}
  done
}
