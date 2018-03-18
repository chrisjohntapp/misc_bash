#!/bin/bash

function bubblesort()
{
    length=${#data[@]}

    for i in $(seq 0 ${length}); do
        for (( j=length; j > i; j-=1 )); do
            if [[ ${data[j-1]} > ${data[j]} ]]; then
                temp=${data[j]}
                data[j]=${data[j-1]}
                data[j-1]=$temp
            fi
        done
    done
}

data=( roger oscar charlie kilo indigo tango )

printf "Initial state:\n"

for i in ${data[@]}; do
    printf "${i}\n"
done

bubblesort

printf "\nFinal state:\n"

for i in ${data[@]}; do
    printf "${i}\n"
done
