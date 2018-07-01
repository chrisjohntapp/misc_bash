#!/bin/bash
#
# Utility functions to check health of services.
#
# vi:syntax=sh
# shellcheck disable=SC2034
_LIB_HEALTHCHECK=1

function pingable() {
    ###########################################################################
    # Check if a FQDN is pingable, allowing for a flaky network. It will allow
    # for occasional dropped packets by adjusting the number of pings to use in
    # the test (using the -p flag). Only if all pings fail will the FQDN be
    # classed as down.
    ###########################################################################
    local func=$(basename "${FUNCNAME[0]}")

    OPTIND=1
    local num_pings

    while getopts ':p:a:s' opt; do
	case "${opt}" in
	    p) num_pings="${OPTARG}" ;;
	    a) local -r alt_resolver="${OPTARG}" ;;
            s) local -r skip_resolver=yes ;;
	    *)
		printf "\nUsage: %s [ -p <number of pings> ] " "${func}"
                printf "[-a ip address] [-s] FQDN\n\n"
                printf "(-p The number of pings to use (default is 3))\n"
                printf "(-a An alternate DNS server for dig test)\n"
                printf "(-s Skip name resolution check)\n\n"
		return 1
		;;
	esac
    done

    for _ in $(seq 2 "${OPTIND}"); do
	shift
    done

    : ${num_pings:=3}

    local -r fqdn="$1"
    if [[ -z "${fqdn}" ]]; then
	printf "No FQDN supplied.\n"
	return 1
    fi

    local resolver
    if [[ -n "${alt_resolver}" ]]; then
	resolver="@${alt_resolver} "
    else
	resolver=""
    fi

    if ! [[ "${skip_resolver}" == yes ]]; then
        local dig_result="$(dig ${resolver}"${fqdn}" a +short)"

        if [[ -z "${dig_result}" ]]; then
            printf "Cannot resolve that FQDN.\n"
            return 2
        fi
    fi

    for i in $(seq ${num_pings}); do
	results[$i]="$(ping -c 1 "${fqdn}" >'/dev/null'; printf "$?\n")"
	sleep 1
    done

    if ! [[ "$(printf "%s" "${results[@]}" | grep 0)" ]]; then
	printf "${fqdn} is not pingable.\n"
	return 3
    fi
}
