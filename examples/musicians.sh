#!/bin/bash

# Use of associative arrays (hashes).

declare -A beatles
beatles=( [singer]=John [bassist]=Paul [drummer]=Ringo [guitarist]=George )

for musician in singer bassist drummer guitarist
do
  echo "The ${musician} is ${beatles[$musician]}"
done
