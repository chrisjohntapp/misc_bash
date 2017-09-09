#!/bin/bash

. /home/me/lib/lib_pingable

# Capturing a string value in addition to the return code can be useful;
# in this case it contains error messages.
result=$(check_pingable hostname.domain)

if [ $? = 0 ] && [ -z "$result" ]; then
  # Copy Dropbox dir to hostname.
  rsync --delete -e 'ssh -p <port number>' -a /home/me/Dropbox me@hostname:/backups/funnel
 
  # If rsync was successful, update timestamp on remote copy. 
  if [ $? = 0 ]; then
    ssh -p <port number> me@hostname touch /backups/funnel/Dropbox
  else
    printf "Something went wrong with the backup.\n"
    exit 1
  fi
else
  printf "check_pingable returned an error: $result.\n"
  exit 1
fi


