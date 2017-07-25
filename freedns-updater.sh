#!/bin/bash

# freedns-updater.sh
# Retrieves current real IP and updates freedns, if required.

[ -s /tmp/freedns ] || echo "undef" > /tmp/freedns

SAVED_IP=$(cat /tmp/freedns) || { echo "$(basename $0) Could not retrieve SAVED_IP" >> /var/log/messages; exit 1; }

#REAL_IP=$(curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//')
REAL_IP=$(curl -s icanhazip.com)

# Check that a usable IP address was retrived.
[ -z $REAL_IP ] && { exit 2; }

# If address has changed, do stuff.
if [ "${SAVED_IP}" != "${REAL_IP}" ]
then
  # Update FreeDNS record.
  curl -s 'http://freedns.afraid.org/dynamic/update.php?VmpEUTZkTDRFd2hjVWpEYW1ZTjdXSURhOjExMjYyMjY1' || { echo "$(basename $0) FreeDNS update failed" >> /var/log/messages; exit 3; }
  
  # Update SAVED_IP.
  echo $REAL_IP > /tmp/freedns || { echo "$(basename $0) Writing /tmp/freedns failed" >> /var/log/messages; exit 4; }
  
  # Log the update.
  echo "$(date '+%b %d %T') $(basename $0) tarp.crabdance.com 'A' record updated to ${REAL_IP}" >> /var/log/messages || { echo "$(basename $0) Writing log failed" >> /var/log/messages; exit 5; }
fi

exit 0
