#!/bin/bash

# shellcheck disable=SC2034
_lib_healthcheck=1

check_pingable()
{
  # Check if a FQDN can be pinged.
  # You can allow for occasional dropped packets by adjusting the number of pings
  # to use in the test (using the -p flag). Only if all pings fail will the fqdn
  # be classed as down.

  OPTIND=1
  local num_pings=3
  local alt_dns

  while getopts 'p:a:' opt; do
    case "$opt" in
      p) num_pings="$OPTARG" ;;
      a) alt_dns="$OPTARG" ;;
      *) printf "\nUsage: check_alive [ -p <number of pings> ] [ -a ip address] fqdn\n
(-p The number of pings to use (default is 3)).\n(-a An alternate DNS server for dig test)\n\n"
         return 1 ;;
    esac
  done

  # Remove any processed options from argv.
  for _ in $(seq 2 $OPTIND); do
    shift
  done

  # Assign remaining argument to variable.
  local fqdn=$1
  if [[ -z "$fqdn" ]]; then
    printf "No fqdn supplied.\n"
    return 1
  fi

  # Check if fqdn is resolvable.
  local insert
  if [[ -n "$alt_dns" ]]; then
    insert="@${alt_dns} "
  else
    insert=""
  fi
  if [[ -z "$(dig ${insert}${fqdn} a +short)" ]]; then
    printf "Cannot resolve that fqdn.\n"
    return 1
  fi

  # Ping the target fqdn.
  for i in $(seq $num_pings); do
    results[$i]=$(ping -c 1 $fqdn >/dev/null; printf "$?\n")
    sleep 1
  done

  # If there are no successful pings, check failed.
  if [[ ! $(printf "%s" "${results[@]}" | grep 0) ]]; then
    printf "$fqdn is not pingable.\n"
    return 1
  fi

  # Clear vars
  unset results
}

# vi:syntax=sh
