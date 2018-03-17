#!/bin/bash

vc_server=<ip address>
operation=poweron
credstore='/etc/vicredentials.xml'
reset_list='ro_vms.txt'


vminfo=$(find /usr/local/vcli -name vminfo.pl) || { echo "Could not find vminfo.pl. Is vcli installed?"; exit 2; }
vmcontrol=$(find /usr/local/vcli -name vmcontrol.pl) || { echo "Could not find vmcontrol.pl. Is vcli installed?"; exit 3; }

vm_string=$($vminfo --server $vc_server --credstore $credstore | grep -e '^Name' | awk '{print $2}')
readarray -t vm_list <<< "$vm_string"

declare -a kill_list

for v in "${vm_list[@]}"; do
  vstripped=${v:6}
  if (grep -Fqx "$vstripped" $reset_list); then
    # echo $vstripped
    kill_list+=("$v")
  fi
done

for k in "${kill_list[@]}"; do
  $vmcontrol --server $vc_server --credstore $credstore --vmname $k --operation $operation 
  sleep 10
  # echo $k
done

