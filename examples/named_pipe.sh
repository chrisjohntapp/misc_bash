#!/bin/sh

mkfifo mypipe

find ${HOME} -type f -name '.mp3"'> mypipe &

while IFS= read -r line; do
    : # Something
done < mypipe

rm mypipe

