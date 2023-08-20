#!/bin/bash

[[ "$#" -eq 1 ]] || { echo "$(basename $0) <cluster id>"; exit 1; }

function k1() {
    local id="Ubuntu 18.04 / Hardway"
    echo "Starting $id"
    sleep 3
    for i in 1 2 3; do
        kubectl uncordon work${i}
    done
}

function k2() {
    local id="Rocky 8.5 / Kubeadm"
    echo "Starting $id"
    sleep 3
    for i in k2c1 k2c2 k2c3 k2w1 k2w2 k2w3; do
        ssh -t tappy@${i} "sudo modprobe br_netfilter && sudo modprobe nf_nat && sudo modprobe xt_REDIRECT && sudo modprobe xt_owner && sudo modprobe iptable_nat && sudo modprobe iptable_mangle && sudo modprobe iptable_filter"
    done
    for i in 1 2 3; do
        kubectl uncordon k2w${i}
    done
}

case $1 in
    k1) k1 ;;
    k2) k2 ;;
    *) { echo "Cluster id not recognised"; exit 2; } ;;
esac

