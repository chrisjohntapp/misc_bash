#!/bin/bash

# Does not change hosts file, fstab, exports

primary_gateway="10.110.73.1"
dr_gateway="192.168.2.254"
primary_net="10.110.73"
dr_net="192.168.2"

os_vendor=$(grep -E "^ID=" /etc/os-release | cut -d"=" -f2 | sed 's/"//g')
os_version=$(grep -E "^VERSION_ID=" /etc/os-release | cut -d"=" -f2 | sed 's/"//g')

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

function restart_networking_centos() {
    log "Restarting network to Apply the new configuration."
    OS_ver=$(lsb_release -a | grep Release | awk '{print $2}'| cut -d '.' -f1)
    if [ $OS_ver -eq 6 ]; then
        service network restart
    fi
    if [ $OS_ver -eq 7 ]; then
        systemctl restart network.service
    fi
}

function check_primary() {
    # Check defined IP from primary site by sending ICMP requests.
    log "Sending ICMP requests to ${primary_gateway}."
    ping -c 1 -t 1 ${primary_gateway} > /dev/null
}

function check_dr() {
    # Ping the replica gateway (DR Site) to make sure of network connectivity.
    log "Testing new IP configurations in DR site by sending ICMP requests to ${dr_gateway}"
    ping -c 1 -t 1 ${dr_gateway} > /dev/null
}

function update_net_conf_centos() {
    log "Collecting network script files."
    ifcfg_files=($(ls /etc/sysconfig/network-scripts/ifcfg-*))
    for ((i=0; i<${#ifcfg_files[@]}; i++)); do
        log "Changing IP range to ${dr_net} on ${ifcfg_files[i]}."
        sed -i "s/${primary_net}/${dr_net}/" ${ifcfg_files[i]}
    done
}

function revert_net_conf_centos() {
    log "Collecting network script files."
    ifcfg_files=($(ls /etc/sysconfig/network-scripts/ifcfg-*))
    for ((i=0; i<${#ifcfg_files[@]}; i++)); do
        log "Changing IP range to ${primary_net} on ${ifcfg_files[i]}."
        sed -i "s/${dr_net}/${primary_net}/" ${ifcfg_files[i]}
    done
}

check_primary
if [ $? -eq 0 ]; then
    log "${primary_gateway} is reachable. No config changes will be applied."
    exit 0
else
    log "${primary_gateway} is not reachable; Assuming we've failed over to DR site."
    log "Updating IP address."
    update_net_conf_${os_vendor}
    restart_networking_${os_vendor}
fi

check_dr
if [ $? -eq 0 ]; then
    log "${dr_gateway} is reachable. This VM appears to be on the DR site."
else
    log "Replica gateway address is not reachable."
    log "Reverting to primary site IP address."
    revert_net_conf_${os_vendor}
    restart_networking_${os_vendor}
fi

