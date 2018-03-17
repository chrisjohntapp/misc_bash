#!/bin/bash
export LOCAL_IP=172.16.62.101
export REMOTE_IP=172.16.62.102
sudo ip link add lxc-gre type gretap remote $REMOTE_IP local $LOCAL_IP ttl 255
sudo brctl addif lxdbr0 lxc-gre
sudo ip link set lxc-gre up
