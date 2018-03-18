#!/bin/bash

# Set custom debug log levels. Includes examples at bottom.

verbose=10 # 1-10, higher is more talkative.
app_name=$(basename $0)
log_file=$(mktemp -p /tmp XXX-${app_name}.log)

function log_msg()
{
    echo "${app_name}: $(date): $@" >> $log_file
}

function debug()
{
    verbosity=$1; shift

    if [[ "$verbose" -gt "$verbosity" ]]; then
        echo "${app_name}: $(date): DEBUG Level ${verbosity}: $@" >> $log_file
    fi
}

function die()
{
    echo "${app_name}: $(date): FATAL ERROR: $@" >> $log_file
    exit 1
}

#==========
# Main
#==========

log_msg "Starting script $0"

echo -n "System info: "

uname || die 'uname command not found.'
log_msg $(uname -a)

cat /etc/redhat-release || debug 8 'Not a RedHat-based system.'
cat /etc/debian_version || debug 8 'Not a Debian-based system.'

cd /proc || debug 5 '/proc filesystem not found.'

grep -q "physical id" /proc/cpuinfo || debug 7 '/proc/cpuinfo virtual file not found.'
log_msg Found "$(grep 'physical id' /proc/cpuinfo | sort -u | wc -l) physical CPUs."

unset IPADDR
if [[ -r /etc/sysconfig/network-scripts/ifcfg-eth0 ]]; then
    . /etc/sysconfig/network-scripts/ifcfg-eth0
else
    debug 4 'icfg-eth0 not found.'
fi

log_msg "eth0 IP address defined as $IPADDR."

log_msg "Script $0 finished."

