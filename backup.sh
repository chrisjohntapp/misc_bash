#!/bin/sh

# backup.sh

if [ $# -lt 1 ]; then 
    echo "No destination defined. Usage: $0 destination" >&2
    exit 1
elif [ $# -gt 1 ]; then
    echo "Too many arguments. Usage: $0 destination" >&2
    exit 1
fi

START=$(date +%s)
rsync -aAXv /* $1 --exclude dev/* --exclude proc/* --exclude sys/* --exclude tmp/* --exclude run/* --exclude mnt/* --exclude media/* --exclude lost+found
FINISH=$(date +%s)
echo "total time: $(( ($FINISH-$START) / 60 )) minutes, $(( ($FINISH-$START) % 60 )) seconds"

touch $1/"Backup from $(date '+%A, %d %B %Y, %T')"
