#!/bin/bash

while read ip name aliases
do
  if [ -n "$name" ]; then
    echo -en "IP is ${ip}, it's name is $name"
    if  [ -n "$aliases" ]; then
      echo "  Aliases are $aliases"
    else
      echo #(blank line)
    fi
  fi
done
