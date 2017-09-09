#!/bin/bash

# check-alive.sh
#
# Pings a host and reports if it's down. Typically run from cron.
#
# You can allow for occasional missed pings by adjusting the number
# of pings to use in the test (using the -p flag). Only if all
# pings fail will the host be classed as down. 
#
# Output (the -o flag) can be to the console ('screen'), the
# logfile ('log'), or to an email recipient ('email' [also sends
# to the log file]).

set -e

screen_out()
{
  echo "$host looks down"
}

log_out()
{
  echo "$(date '+%b %d %T') $host looks down" >> $logfile
}

email_out()
{
  echo "$host looks down" | mailx -s "$host looks down" $email_recip 
}

usage()
{
  echo "Usage: $(basename $0) -t <target host> -p <number of pings> -o <output type> [-r <email recipient>]
  -t Target (a FQDN)
  -p The number of pings to use in the test (an integer)
  -o Output type ('screen', 'email', or 'log')
  -r Email recipient (an email address)
  -h Help (this message)"
}

check_resolv()
{
  if [[ -z "$(dig $host a +short)" ]]; then
    echo "Cannot resolve that hostname. Using a FQDN is recommended."
    exit 2
  fi
}

validate_output_type()
{
  if [[ ! $output_type =~ ^(screen|email|log)$ ]]; then
    usage
    exit 1
  fi
}

run_test()
{
  for i in $(seq $num_pings); do
    results[$i]=$(ping -c 1 $host >/dev/null; echo $?)
    sleep 1
  done
}

process_results()
{
  if [[ ! $(echo ${results[@]} | grep 0) ]]; then
    case "${output_type}" in
      'screen') screen_out; log_out ;;
       'email') email_out; log_out ;;
         'log') log_out ;;
    esac
  fi
}

#==========
# Main
#==========

if [[ $# -lt 6 ]] || [[ $1 == '--help' ]]; then
  usage
  exit 1
fi

while getopts t:p:o:r:h opt; do
  case "$opt" in
    t) host="$OPTARG" ;;
    p) num_pings="$OPTARG" ;;
    o) output_type="$OPTARG" ;;
    r) email_recip="$OPTARG" ;;
    h) usage
       exit 1 ;;
  esac
done

logfile=/var/log/check-alive.log

check_resolv
validate_output_type
run_test
process_results

# EOF

