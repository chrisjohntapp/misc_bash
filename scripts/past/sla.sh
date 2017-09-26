#!/bin/bash

float_eval()
{
  local stat=0
  local result=0.0
  if [[ $# -gt 0 ]]; then
    result=$(echo "scale=$float_scale; $*" | bc -q 2>/dev/null)
    stat=$?
    if [[ $stat -eq 0  &&  -z "$result" ]]; then stat=1; fi
  fi
  echo $result
  return $stat
}

id=$(id -u)
if [ $id == 0 ]; then
  printf "Don't run this as root, you numpty!\n"
  exit 1
fi 

now=$(date --date='-1 hour' "+%Y-%m-%e %X")
past=$(date --date='-1 day -1 hour' "+%Y-%m-%e %X")

printf "\n\n...working out uptime for the 24 hour period between $past & $now.  Please be patient - I'm a bit slow.\n\n"

float_scale=5

## Optional - insert arbitrary dates (must replace now and past in result query to use these)
#echo "Enter the starting timestamp: (format is like this '2012-10-24 00:00:00' (without the quotes))"
#read start_timestamp
#echo "Enter the ending timestamp: "
#read end_timestamp

cd $HOME
cp /opt/voiptestdaemon/db/testframework.db ~

result=$(sqlite3 ~/testframework.db "SELECT result, count(*) FROM test_run WHERE datetime((run_time)/1000, 'unixepoch') > '$past' AND datetime((run_time)/1000, 'unixepoch') < '$now' GROUP BY result;")

failed=$(echo $result | cut -d"|" -f2 | cut -d" " -f1)
succeeded=$(echo $result | cut -d"|" -f3)

printf "%16s\t%16s\n" "Failed:" "$failed"
printf "%16s\t%16s\n" "Succeeded:" "$succeeded"

total=$(($failed + $succeeded))
failurep=$(float_eval "$failed / $total")

printf "%16s\t%16s\n" "Total:" "$total"
#printf "%16s\t%16s\n" "Failure Percentage:" "$failurep"

slbase=$(float_eval "1 - $failurep")
slp=$(float_eval "$slbase * 100")

printf "\n"
printf "%16s\t%16s\n" "Service Level:" "$slp%"
printf "\n"

# EOF
