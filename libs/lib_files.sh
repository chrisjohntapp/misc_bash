#!/bin/bash
#
# Utility functions related to file operations.
#
# vi:syntax=sh
# shellcheck disable=SC2034
_LIB_FILES=1

function remove_file_end_strings() {
  #=====================================================================
  # Removes a string from the end of all filenames in a given directory.
  #=====================================================================
  OPTIND=1
  while getopts 'd:h' argv; do
    case "${argv}" in
      d) local target_dir="${OPTARG}" ;;
      h) printf "Usage: remove_file_end_strings [ -d <work directory> ] <string to remove>\n" ;;
    esac
  done

  : ${target_dir:=$PWD}

  for _ in $(seq 2 "${OPTIND}"); do
    shift
  done

  if [[ -z "$1" ]]; then
    printf "No string supplied.\n"
    return 1
  else
    local end_string=$1
  fi

  local file
  find "${target_dir}" -type f -name "*${end_string}" -print0 \
    | while read -d $'\0' file; do mv "${file}" "${file%${end_string}}"; done
}

function tip() {
  #==========================================================================
  # Allows quick writing of cli notes/tips to a specific file within the tips
  # library. Alternatively prints the whole named file to stdout for reading,
  # or lists the contents of the tips library.
  #==========================================================================
  local -r TIPS_PATH='Dropbox/CLI_tips'
  if [[ $# -gt 1 ]] && [[ -r "${HOME}/${TIPS_PATH}/${1}.txt" ]]; then
    f=$1; shift
    printf "$*" >> "${HOME}/${TIPS_PATH}/${f}.txt"
  elif [[ $# -eq 1 ]]; then
    if [[ "${1}" = '-l' ]]; then
      ls -1 "${HOME}/${TIPS_PATH}" | less -F
    else
      local -r TIP_FILE="${HOME}/${TIPS_PATH}/${1}.txt"
      if [[ -r "${TIP_FILE}" ]]; then
        cat "${TIP_FILE}" | less -F
      else
        printf "%s%s\n" "Cannot find tip file: " "${TIP_FILE}"
      fi
    fi
  else
    printf "Usage: tip [ -l ] | [ type ] [ Notes to add to file ]\n"
  fi
}

function edit_tip() {
  #==========================================================
  # Opens the named file within the tips library for editing.
  #==========================================================
  local -r TIPS_PATH='Dropbox/CLI_tips'
  if [[ $# -eq 1 ]]; then
    local filename="${HOME}/${TIPS_PATH}/${1}.txt"
    if [[ -w "${filename}" ]]; then
      vim "${filename}"
    else
      printf "File does not exist.\n"
    fi
  else
    printf "Usage: edittip filename\n"
  fi
}
