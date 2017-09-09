#!/bin/bash

# List all packages in a particular repo.

[ $# = 1 ] || { printf "Usage: $(basename $0) <repo name (string/substring)>\n"; exit 1; }

cd /var/lib/apt/lists && cat *$1* | grep "^Package: " | sed 's/^Package: //' | sort -u

