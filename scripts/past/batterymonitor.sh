#!/bin/bash

xterm -e {
A=$(cat /proc/acpi/battery/BAT0/info | awk '/last full capacity/{print $4}') ;
B=$(cat /proc/acpi/battery/BAT0/state | awk '/remaining capacity/{print $3}') ; 

let C=$B*100/$A ; 
echo "$C%" ;

read -s -n1 -p "press any key to exit..." ;
printf "\n"
