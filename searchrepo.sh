#!/bin/bash

cd /var/lib/apt/lists/
cat *$1* | grep "^Package: " | sed 's/^Package: //' | sort -u

