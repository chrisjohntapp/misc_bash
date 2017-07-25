#!/bin/bash
# bandit.sh.   Fruit machine simulator
# (RANDOM variable is between 1 and 32767)

RANDOM=$$
X=$(echo $RANDOM)
Y=$(echo $RANDOM)
Z=$(echo $RANDOM)

if 
  [ $X -le 10922 ] ; then
  X=Apple
elif
  [ $X -ge 10923 ] && [ $X -le 21844 ] ; then
  X=Orange
else
  X=Banana
fi

if 
  [ $Y -le 10922 ] ; then
  Y=Apple
elif
  [ $Y -ge 10923 ] && [ $Y -le 21844 ] ; then
  Y=Orange
else
  Y=Banana
fi

if 
  [ $Z -le 10922 ] ; then
  Z=Apple
elif
  [ $Z -ge 10923 ] && [ $Z -le 21844 ] ; then
  Z=Orange
else
  Z=Banana
fi

printf '%-s\t%-s\t%-s\t\n' "$X" "$Y" "$Z"