#!/bin/bash

# Use of associative arrays (hashes).

declare -A beatles
beatles=( [singer]=John [bassist]=Paul [drummer]=Ringo [guitarist]=George )

# Iterate over keys.
for instrument in ${!beatles[@]}
do
  echo "The ${instrument} is ${beatles[$instrument]}"
done
