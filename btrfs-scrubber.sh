#!/bin/bash

# btrfs-scrubber.sh
# Scrubs all subvolumes listed in 'subvols' array, checks them
# for errors, and sends email alert if errors are found.

subvols=( '/home/' )
recipient=<my email address>

btrfs=$(which btrfs)

scrub_subvols()
{
  for subvol in "${subvols[@]}"
  do
    $btrfs scrub start $subvol
  done
}

check_for_errors()
{
  for subvol in "${subvols[@]}"
  do
    results=$($btrfs scrub status $subvol)

    if [[ $results =~ ' 0 errors' ]]
    then
        : # All is well.
        echo "$(date '+%b %d %T') $(basename $0) No errors found on ${subvol}." >> /var/log/messages
        break
    else
        # We have a problem. Send email and log error.
        echo "Error(s) detected in $subvol subvolume -- revert to last btrfs snapshot." | mailx \
        -s "$(hostname -s) filesystem error(s) detected" ${recipient}
        echo "$(date '+%b %d %T') $(basename $0) Errors found on $subvol -- revert to snapshot." \
        >> /var/log/messages
    fi
  done
}

# Run the thing
scrub_subvols
sleep 4h
check_for_errors
