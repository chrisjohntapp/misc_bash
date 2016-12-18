#!/usr/local/bin/bash

set -e

# Scientific 6.5
rsync -avkSH --bwlimit=500000 --delete --exclude=archive/debuginfo --exclude=archive/obsolete --exclude=i386 rsync://rsync.mirrorservice.org/ftp.scientificlinux.org/linux/scientific/6.5/ /var/ftp/mirror/sl/6.5/ && touch /var/ftp/mirror/sl/6.5/timestamp || { echo "$(basename $0) failed mirroring sl 6.5" >> /var/log/mirror.log; exit 1; }

echo "$(date '+%a %d %T') $(basename $0) SL 6.5 mirrored." >> /var/log/mirror.log

# Scientific 6.6
rsync -avkSH --bwlimit=500000 --delete --exclude=archive/debuginfo --exclude=archive/obsolete --exclude=i386 rsync://rsync.mirrorservice.org/ftp.scientificlinux.org/linux/scientific/6.6/ /var/ftp/mirror/sl/6.6/ && touch /var/ftp/mirror/sl/6.6/timestamp || { echo "$(basename $0) failed mirroring sl 6.6" >> /var/log/mirror.log; exit 2; }

echo "$(date '+%a %d %T') $(basename $0) SL 6.6 mirrored." >> /var/log/mirror.log

# Scientific 7.0
rsync -avkSH --bwlimit=500000 --delete --exclude=archive/debuginfo --exclude=archive/obsolete rsync://rsync.mirrorservice.org/ftp.scientificlinux.org/linux/scientific/7.0/ /var/ftp/mirror/sl/7.0/ && touch /var/ftp/mirror/sl/7.0/timestamp || { echo "$(basename $0) failed mirroring sl 7.0" >> /var/log/mirror.log; exit 3; }

echo "$(date '+%a %d %T') $(basename $0) SL 7.0 mirrored." >> /var/log/mirror.log

