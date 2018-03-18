#!/bin/bash

read -rep "Which city are you closest to?: " city
case $city in
    "New York"|London|Paris|Tokyo)
	# You can identify the capital cities and still fall through to
	# match the specific country below.
	echo "That is a capital city" ;;&
    Chicago|Detroit|"New York"|Washington)
	echo "You are in the USA" ;;
    London|Edinburgh|Cardiff|Dublin)
	echo "You are in the United Kingdom" ;;
    "Ramsey Street")
	# You can still fall through and run the generic Australian code
	# by using the ;& ending.
	echo "G’Day Neighbour!" ;&
    Melbourne|Canberra|Sydney)
	echo "You are in Australia" ;;
    Paris)
	echo "You are in France" ;;
    Tokyo)
	echo "You are in Japan" ;;
    N*)
	# We have already matched “New York” and ended it with a ;;
	# so New York will not fall through to this test. Other places
	# beginning with N will fall through to here.
	echo "Your word begins with N but is not New York" ;;
    *)
	echo "I’m sorry, I don’t know anything about $city" ;;
esac


read -rep "Give me a word: " input

printf "You gave me some "

case ${input} in
    *[[:lower:]]*) printf "Lowercase " ;;&
    *[[:upper:]]*) printf "Uppercase " ;;&
    *[[:digit:]]*) printf "Numerical " ;;&
    *) printf "input.\n" ;;
esac

