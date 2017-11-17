#!/bin/bash

vc_server=<ip address>
credstore='/etc/vicredentials.xml'

vminfo=$(find /usr/local/vcli -name vminfo.pl) || { echo "Could not find vminfo.pl. Is vcli installed?"; exit 1; }

vm_string=$($vminfo --server $vc_server --credstore $credstore | grep -e '^Name' | awk '{print $2}')
readarray -t vm_list <<< "$vm_string"

printf "%s\n" "${vm_list[@]}"
