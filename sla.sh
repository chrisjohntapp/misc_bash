#!/bin/bash

ID=$(id -u)
if [ $ID == 0 ] 
then
    printf "Don't run this as root, you numpty!\n"
    exit 1
fi 

NOW=$(date --date='-1 hour' "+%Y-%m-%e %X")
THEN=$(date --date='-1 day -1 hour' "+%Y-%m-%e %X")

printf "\n\n"
printf "...working out uptime for the 24 hour period between $THEN & $NOW.  Please be patient - I'm a bit slow.\n\n"

float_scale=5

function float_eval()
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

## Optional - insert arbitrary dates (must replace NOW and THEN in RESULT query to use these)
#echo "Enter the starting timestamp: (format is like this '2012-10-24 00:00:00' (without the quotes))"
#read START_TIMESTAMP
#echo "Enter the ending timestamp: "
#read END_TIMESTAMP

cd $HOME

cp /opt/voiptestdaemon/db/testframework.db ~

RESULT=$(sqlite3 ~/testframework.db "SELECT result, count(*) FROM test_run WHERE datetime((run_time)/1000, 'unixepoch') > '$THEN' AND datetime((run_time)/1000, 'unixepoch') < '$NOW' GROUP BY result;")

FAILED=$(echo $RESULT | cut -d"|" -f2 | cut -d" " -f1)
SUCCEEDED=$(echo $RESULT | cut -d"|" -f3)

printf "%16s\t%16s\n" "Failed:" "$FAILED"
printf "%16s\t%16s\n" "Succeeded:" "$SUCCEEDED"

TOTAL=$(($FAILED + $SUCCEEDED))
FAILUREP=$(float_eval "$FAILED / $TOTAL")

printf "%16s\t%16s\n" "Total:" "$TOTAL"
#printf "%16s\t%16s\n" "Failure Percentage:" "$FAILUREP"

SLBASE=$(float_eval "1 - $FAILUREP")
SLP=$(float_eval "$SLBASE * 100")

printf "\n"
printf "%16s\t%16s\n" "Service Level:" "$SLP%"
printf "\n"

