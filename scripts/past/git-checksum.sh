#!/bin/bash
# git-checksum.sh
# To be run from cron every 5mins?

[[ ! -z "$(which git)" ]] || { echo "git not installed"; exit 1; }

#CHECKDIRS=( "/var/www/vhosts/www.example.co" \
#	"/var/www/vhosts/www.exampleglobal.com" \
#	"/var/www/vhosts/www.example.co.uk.popcorn" )

CHECKDIRS=( "/root/repos/beaver-patrol" \
	"/root/repos/newproj" \
	"/root/repos/hello-project" )

for i in "${CHECKDIRS[@]}"
do
	cd $i	

	STATUS=$(git status -s)
	
	[[ ! -z "${STATUS}" ]] && echo "Git checksum failed on ${i}" #| mailx -s "Git checksum failed on ${i}" me@email.com
done

exit 0

