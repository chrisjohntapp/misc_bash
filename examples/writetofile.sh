#!/bin/sh

myfunc()
{
  thefile=$1
  echo "Hello number $2" >> $thefile
}

#==========
# Main
#==========

file1=/tmp/file.1
file2=$(mktemp)

for i in 1 2 3
do
  myfunc $file1 $i
  myfunc $file2 $(expr $i + 1)
done

echo "FILE 1 says:"
cat $file1
echo "FILE 2 says:"
cat $file2

> $file1 # Erase contents of file.1

for i in 11 12 13
do
  myfunc $file1 $i
  myfunc $file2 $(expr $i + 1)
done

echo "FILE 1 says:"
cat $file1
echo "FILE 2 says:"
cat $file2

rm -f $file1 $file2
