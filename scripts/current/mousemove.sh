#!/bin/bash

XRANGE=1350
YRANGE=750

while (true)
do
  x=$RANDOM
  y=$RANDOM

  let "x %= $XRANGE"
  let "y %= $YRANGE"

  sleep 4 && xdotool mousemove $x $y 
done
