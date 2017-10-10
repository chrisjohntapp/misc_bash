#!/bin/bash
#
# Utility functions to check health of services.
#
# vi:syntax=sh
# shellcheck disable=SC2034
_LIB_HEALTHCHECK=1

function pingable() {
  ##############################################################################
  # Check if a FQDN is pingable, allowing for a flaky network.
  # You can allow for occasional dropped packets by adjusting the number of
  # pings to use in the test (using the -p flag). Only if all pings fail will
  # the FQDN be classed as down.
  ##############################################################################
  OPTIND=1
  local num_pings=3

  while getopts 'p:a:' opt; do
    case "${opt}" in
      p) num_pings="${OPTARG}" ;;
      a) local -r ALT_DNS="${OPTARG}" ;;
      *)
        printf "\nUsage: check_alive [ -p <number of pings> ] \
[ -a ip address] FQDN\n
(-p The number of pings to use (default is 3)).\n(-a An alternate DNS server \
for dig test)\n\n"
        return 1
        ;;
    esac
  done

  for _ in $(seq 2 "${OPTIND}"); do
    shift
  done

  local -r FQDN=$1
  if [[ -z "${FQDN}" ]]; then
    printf "No FQDN supplied.\n"
    return 1
  fi

  local insert
  if [[ -n "${ALT_DNS}" ]]; then
    insert="@${ALT_DNS} "
  else
    insert=""
  fi

  if [[ -z "$(dig "${insert}""${FQDN}" a +short)" ]]; then
    printf "Cannot resolve that FQDN.\n"
    return 2
  fi

  for i in $(seq ${num_pings}); do
    results[$i]="$(ping -c 1 "${FQDN}" >'/dev/null'; printf "$?\n")"
    sleep 1
  done

  if ! [[ "$(printf "%s" "${results[@]}" | grep 0)" ]]; then
    printf "${FQDN} is not pingable.\n"
    return 3
  fi
}
