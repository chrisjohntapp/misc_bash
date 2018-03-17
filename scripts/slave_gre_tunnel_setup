#!/bin/bash
export LOCAL_IP=172.16.62.102
export REMOTE_IP=172.16.62.101
sudo brctl addbr multibr0
sudo ip link set multibr0 up
sudo ip link add lxc-gre type gretap remote $REMOTE_IP local $LOCAL_IP ttl 225
sudo brctl addif multibr0 lxc-gre
sudo ip link set lxc-gre up
