#!/bin/bash

while IFS=: read -a userdetails; do
    unset user

    gecos=${userdetails[4]%%,*}
    username=${userdetails[0]}
    user=${gecos:-$username}

    if [[ -d "${userdetails[5]}" ]]; then
        echo "${user}’s directory ${userdetails[5]} exists"
    else
        echo "${user}’s directory ${userdetails[5]} doesn’t exist"
    fi
done < /etc/passwd
