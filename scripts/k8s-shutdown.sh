#!/bin/bash

for i in 1 2 3; do kubectl drain work${i} --delete-emptydir-data --ignore-daemonsets; done

if [[ $? != 0 ]]; then
    printf "Failed to drain all worker nodes\n"
    exit 1
else
    for i in 1 2 3; do printf "Shutting down work${i}\n"; ssh work${i} sudo shutdown -P +1; done
fi

if [[ $? != 0 ]]; then
    printf "Failed to shut down all worker nodes\n"
    exit 2
else
    for i in 1 2 3; do printf "Shutting down cont${i}\n"; ssh cont${i} sudo shutdown -P +1; done
fi

if [[ $? != 0 ]]; then
    printf "Failed to shut down all controller nodes\n"
    exit 3
else
    echo "Shutting down haproxy1\n"; ssh haproxy1 sudo shutdown -P +1 &
fi

if [[ $? != 0 ]]; then
    printf "Failed to shut down haproxy1\n"
else
    echo "Shutting down hpe-proliant-02\n"
    ssh -i ~/.ssh/id_rsa_scooter-windaz root@hpe-proliant-02 sleep 5 && poweroff &
fi

if [[ $? != 0 ]]; then
    printf "Failed to shut down hpe-proliant-02\n"
else
    printf "All elements shut down cleanly\n"
fi
