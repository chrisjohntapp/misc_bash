#!/bin/bash

hobbies=( skiing dogging )

hobbies[${#hobbies[@]}]=rowing
for hobby in "${hobbies[@]}"
do
  echo "Hobby: $hobby"
done
