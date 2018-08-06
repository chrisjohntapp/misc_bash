#!/bin/bash

# Version for Centos 7
# Does not change hosts file, fstab, exports

primary_ip_check="10.110.73.1"
replica_ip_check="192.168.2.254"
primary_net="10.110.73"
replica_net="192.168.2"

# Logging
readonly SCRIPT_NAME=$(basename $0)
function log() {
    echo "$(date) $@"
    logger -s "$(date) $@" 2>> /var/log/dr.log
}
function err() {
    echo "$(date) $@" >&2
    logger -s "$(date) $@" 2>> /var/log/dr.log
}

function restart_networking {
    log "Restarting network to Apply the new configuration."
    OS_ver=$(lsb_release -a | grep Release | awk '{print $2}'| cut -d '.' -f1)
    if [ $OS_ver -eq 6 ]; then
        service network restart
    fi
    if [ $OS_ver -eq 7 ]; then
        systemctl restart network.service
    fi
}

# Check defined IP from primary site by sending ICMP requests.
log "Sending ICMP requests to ${primary_ip_check}."
ping -c 1 -t 1 ${primary_ip_check} > /dev/null
if [ $? -eq 0 ]; then
    log "${primary_ip_check} is reachable in primary site. No change will be applied on configurations."
    exit 0
else
    log "${primary_ip_check} is not reachable; changing IP address."
    log "Collecting network script files."
    ifcfg_files=($(ls /etc/sysconfig/network-scripts/ifcfg-*))
    for ((i=0; i<${#ifcfg_files[@]}; i++)); do
        #change IP range according to each array elements
        log "Changing IP range to ${replica_net} on ${ifcfg_files[i]}."
        sed -i "s@${primary_net}@${replica_net}@" ${ifcfg_files[i]}
    done
    restart_networking
fi

# Ping the replica gateway (DR Site) to make sure of network connectivity.
log "Testing new IP configurations in DR site by sending ICMP requests to ${replica_ip_check}"
ping -c 1 -t 1 ${replica_ip_check} > /dev/null
if [ $? -eq 0 ]; then
    log "$replica_ip_check is reachable and there is no problem. This is replica virtual machine."
else
    # Ping unsuccessful, reverting to primary site IP range.
    log "Primary and replica addresses are not reachable; something is wrong!"
    log "Applying primary site configuration."
    log "Collecting network script files."
    ifcfg_files=($(ls /etc/sysconfig/network-scripts/ifcfg-*))
    for ((i=0; i<${#ifcfg_files[@]}; i++)); do
        log "Changing IP range to $primary_net on ${ifcfg_files[i]}."
        sed -i "s@${replica_net}@${primary_net}@" ${ifcfg_files[i]}
    done
    restart_networking
fi
