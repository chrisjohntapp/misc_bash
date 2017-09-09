#!/bin/bash

# wrapper for dd to act like Solaris' mkfile utility.

function usage()
{
  echo "Usage: mkfile [ -i infile ] [ -q ] [ -b blocksize[b|k|m|g] ] size[b|k|m|g] filename"
  echo "Blocksize is 512 bytes by default"
  exit 2
}

function humanreadable()
{
  multiplier=1
  case $1 in
    *b) multiplier=1          ;;
    *k) multiplier=1024       ;;
    *m) multiplier=1048576    ;;
    *g) multiplier=1073741824 ;;
  esac
  numeric=$(echo $1 | tr -d 'k' | tr -d 'm' | tr -d 'g' | tr -d 'b')
  echo $(( $numeric * $multiplier ))
  # expr $numeric \* $multiplier # Alternative.
}

#==========
# Main
#==========

# mkfile uses 512 byte blocks by default - so shall we.
bs=512
quiet=0
INFILE=/dev/zero

while getopts 'i:b:qh' argv
do
  case $argv in
    i) INFILE=$OPTARG ;;
    b) bs=$OPTARG     ;;
    q) quiet=1        ;;
    h) usage          ;;
  esac
done

# Remove all processed options from the argument list.
for i in $(seq 2 ${OPTIND})
do
  shift
done

# TODO: Input validation for last two arguments.
if [ "$#" -ne "2" ]; then
  usage
fi

SIZE=$(humanreadable $1)
FILENAME="$2"

BS=$(humanreadable $bs)

COUNT=$(( $SIZE / $BS ))
CHECK=$(( $COUNT * $BS ))

if [ "$CHECK" -ne "$SIZE" ]; then
  echo "Warning: Due to the blocksize requested, the file created will be"\
      "$(( $COUNT * $BS )) bytes and not $SIZE bytes"
fi

# Use the best 'dd' implementation available.
ddb=$(which dcfldd 2>/dev/null) || ddb=$(which dd 2>/dev/null)

echo "Creating $SIZE byte file ${FILENAME}..."
$ddb if="$INFILE" bs=$BS count=$COUNT of="$FILENAME" 2>/dev/null
ddresult=$?

if [ "$quiet" -ne "1" ]; then
  if [ "$ddresult" -eq "0" ]; then
    echo "Finished"
  else
    echo "An error occurred. dd returned code $ddresult"
  fi
fi

exit $ddresult

# EOF
