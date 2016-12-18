#!/bin/bash

# btrfs-snapshot.sh
# Snapshots subvolumes listed in 'subvols' array, and deletes old snapshots.
# <chrisjohntapp@gmail.com>

subvols=( '/home/' )
die_days=14

cur_date=$(date "+%d-%m-%Y")
die_date=$(date "+%d-%m-%Y" -d "${die_days} days ago")


btrfs=$(which btrfs) || \
{ echo "error: could not find btrfs binary" >> /var/log/btrfs/snapshot.log; exit 1; }

take_snapshots()
{
  for subvol in ${subvols[@]}
  do
    $btrfs subvolume snapshot $subvol ${subvol}.snapshots/${cur_date} || \
    { echo "error: could not create a snapshot of volume $subvol" >> /var/log/btrfs/snapshot.log; exit 2; }
  done
}

delete_old_snapshots()
{
  for subvol in ${subvols[@]}
  do
    cd ${subvol}.snapshots
    $btrfs subvolume delete $die_date || \
    { echo "error: could not delete snapshot of volume $subvol from $die_date" >> /var/log/btrfs/snapshot.log; exit 3; }
  done
}

# Run the thing
take_snapshots
delete_old_snapshots
