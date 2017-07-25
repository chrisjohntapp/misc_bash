#!/bin/bash

PATH=$PATH:/usr/sbin/
usage='Usage: $(basename $0) [-t|-w] <hostname>'

sweetums='74:46:a0:fe:ee:7c'

hostlist

if [[ $# -lt 2 ]]; then
  echo "$usage"
  exit 1
fi



case "$1" in
  -t) for i in "$@"; do
        if (argument matches an entry in hostlist)
          test_awake
        fi
      done ;;

  -w) for i in "$@"; do
        if (argument matches an entry in hostlist)
          wake
        fi
      done ;;

  *) echo "$usage"
     exit 2 ;;
esac


sudo etherwake -i eth0 74:46:a0:fe:ee:7c

if [[ ! $? -eq 0 ]]; then
  echo "Failed for some reason."
  exit 1 
fi

ping sweetums
