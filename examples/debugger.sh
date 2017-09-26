#!/bin/bash

LOGFILE=/tmp/myscript.log
VERBOSE=10 # 1-10; Higher is more talkative.
APPNAME=$(basename $0)

function logmsg()
{
  echo "${APPNAME}: $(date): $@" >> $LOGFILE
}

function debug()
{
  verbosity=$1
  shift
  if [ "$VERBOSE" -gt "$verbosity" ]; then
    echo "${APPNAME}: $(date): DEBUG Level ${verbosity}: $@" >> $LOGFILE
  fi
}

function die()
{
  echo "${APPNAME}: $(date): FATAL ERROR: $@" >> $LOGFILE
  exit 1
}

#==========
# Main
#==========

logmsg Starting script $0
echo -n "System info: "
uname -a || die uname command not found.
logmsg $(uname -a)
if [ -r /etc/redhat-release ]; then
  cat /etc/redhat-release
else
  debug 8 Not a RedHat-based system
fi
cat /etc/debian_version || debug 8 Not a Debian-based system
cd /proc || debug 5 /proc filesystem not found.
grep -q "physical id" /proc/cpuinfo || debug 8 /proc/cpuinfo virtual file not found.
logmsg Found $(grep "physical id" /proc/cpuinfo | sort -u | wc -l) physical CPUs.
unset IPADDR
if [ -r /etc/sysconfig/network-scripts/ifcfg-eth0 ]; then
  . /etc/sysconfig/network-scripts/ifcfg-eth0
else
  die icfg-eth0 not found
fi
logmsg eth0 IP address defined as $IPADDR
logmsg Script $0 finished.

