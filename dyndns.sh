#!/bin/bash

CURR_IP=`grep <hostname> /etc/hosts | cut -f1`
NEW_IP=`curl ifconfig.me`
EMAIL_TO=<my email address>
SUBJECT="<foobar> IP address has changed!"

if [ "$CURR_IP" != "$NEW_IP" ]
then
	echo "New home IP: $NEW_IP" | mailx -r "$EMAIL_TO" -s "$SUBJECT" "<foobar>"
fi
