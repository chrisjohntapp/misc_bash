#!/bin/bash

search_term="foobar"

mapfile lines < <(ps -ef)

declare -a procs
for i in "${lines[@]}"; do
  if [[ "$i" =~ "$search_term" ]]; then
    procs+=("$i")
  fi
done

if [ "${#procs[@]}" -ge 3 ]; then
  echo "A process already exists. Exiting without creating another"
  exit 0
fi

