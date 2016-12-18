#!/bin/bash

# This script is a wrapper around vcli. It takes a single string argument.
# It retrieves a list of VMs currently registered with the vCenter, and shuts
# down any which contain the string as a substring of their name.

[[ $# == 1 ]] || { echo "Usage: $0 <name of vm to power off (friendly / host name)>"; exit 1; }

export PERL5LIB=/opt/vmware-vsphere-cli-distrib/lib

target=$1 ; target="${target%\\n}"
operation='poweroff'

vc_server='192.168.30.210'
credstore='/etc/vicredentials.xml'

vminfo=$(find /opt/vmware-vsphere-cli-distrib -name vminfo.pl) || { echo "Could not find vminfo.pl. Is vcli installed?"; exit 2; }
vmcontrol=$(find /opt/vmware-vsphere-cli-distrib -name vmcontrol.pl) || { echo "Could not find vmcontrol.pl. Is vcli installed?"; exit 3; }

vm_string=$($vminfo --server $vc_server --credstore $credstore | grep -e '^Name' | awk '{print $2}')
readarray -t vm_list <<< "$vm_string"

regex=".*${target}.*"
declare -a kill_list

for v in "${vm_list[@]}"; do
  if [[ $v =~ $regex ]]; then
    kill_list+=("$v")
  fi
done

for k in "${kill_list[@]}"; do
  $vmcontrol --server $vc_server --credstore $credstore --vmname $k --operation $operation
done

