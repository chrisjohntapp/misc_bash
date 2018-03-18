#!/bin/sh

# calculate the length of the hypotenuse of a Pythagorean triangle
# using hypotenuse^2 = adjacent^2 + opposite^2

read -rep "Adjacent length? " adjacent
read -rep "Opposite length? " opposite

o_squared=$(( $opposite ** 2 ))
a_squared=$(( $adjacent ** 2 ))
h_squared=$(( $o_squared + $a_squared ))

hypotenuse=$(printf "scale=3; sqrt ($h_squared)\n" | bc)

printf "The Hypotenuse is %s\n" "${hypotenuse}"

