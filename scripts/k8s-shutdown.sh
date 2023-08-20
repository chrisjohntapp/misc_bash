#!/bin/bash

[[ "$#" -eq 1 ]] || { echo "$(basename $0) <cluster id>"; exit 1; }

function k1() {
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
        printf "All elements shut down cleanly\n"
    fi
}

function k2() {
    for i in 1 2 3; do kubectl drain k2w${i} --delete-emptydir-data --ignore-daemonsets; done
    
    if [[ $? != 0 ]]; then
        printf "Failed to drain all worker nodes\n"
        exit 1
    else
        for i in 1 2 3; do printf "Shutting down k2w${i}\n"; ssh k2w${i} sudo shutdown -P +1; done
    fi
    
    if [[ $? != 0 ]]; then
        printf "Failed to shut down all worker nodes\n"
        exit 2
    else
        for i in 1 2 3; do printf "Shutting down k2c${i}\n"; ssh k2c${i} sudo shutdown -P +1; done
    fi
    
    if [[ $? != 0 ]]; then
        printf "Failed to shut down all controller nodes\n"
        exit 3
    fi
}


case $1 in
    k1) k1 ;;
    k2) k2 ;;
    *) { echo "Cluster id not recognised"; exit 2; } ;;
esac

