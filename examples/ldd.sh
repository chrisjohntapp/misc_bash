#!/bin/bash

# mktemp will give a pattern like "/tmp/tmp.U3XOAi92I2"
tempfile=$(mktemp)
echo "Temporary file is $tempfile"

logfile="/tmp/libraries.txt"
# If logfile exists from a previous run, delete it.
[ -f $logfile ] && rm -f $logfile

# Trap on:
# 1 = SIGHUP  (Hangup of controlling terminal or death of parent)
# 2 = SIGINT  (Interrupted by the keyboard)
# 3 = SIGQUIT (Quit signal from keyboard)
# 6 = SIGABRT (Aborted by abort(3))
# 9 = SIGKILL (Sent a kill command)

trap cleanup 1 2 3 6 9

function cleanup
{
  echo "Caught signal - tidying up.."
  rm -f $tempfile
  echo "Done. Exiting"
}

#==========
# Main
#==========

find $1 -type f -print | while read filename
do
  ldd ${filename} > ${tempfile}
  if [ "$?" -eq "0" ]; then
    let total=$total+1
    echo "File $filename uses libraries:" >> $logfile
    cat $tempfile >> $logfile
    echo >> $logfile
  fi
done

rm -f $tempfile
echo "Found $(grep -c "^File " $logfile) files in $1 linked to libraries"
echo "Results in $logfile"
