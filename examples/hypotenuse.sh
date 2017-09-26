#!/bin/sh
# calculate the length of the hypotenuse of a Pythagorean triangle
# using hypotenuse^2 = adjacent^2 + opposite^2

echo -n "Enter the Adjacent length: "
read adjacent
echo -n "Enter the Opposite length: "
read opposite

osquared=$(($opposite ** 2))
asquared=$(($adjacent ** 2))
hsquared=$(($osquared + $asquared))

hypotenuse=$(echo "scale=3;sqrt ($hsquared)" | bc)

echo "The Hypotenuse is $hypotenuse"

