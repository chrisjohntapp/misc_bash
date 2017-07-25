#!/bin/bash

################################################################
## Monitors available battery power, and in the event it      ##
## drops below a critical threshold (as determined by the     ## 
## variable "CRITICAL"), gracefully unmounts external         ##
## filesystems, shuts down all vms, and shuts down the host.  ##
################################################################

# emergency-powerdown.sh

# Set critical threshold here (in mWh's)
CRITICAL=15000

# Set battery variables
CURRENT_STATE=$(cat /proc/acpi/battery/BAT0/state | grep remaining | sed 's/remaining capacity:      //' | sed 's/ mWh//')
CHARGING_STATE=$(cat /proc/acpi/battery/BAT0/state | grep charging | sed 's/charging state:          //')

# Write details to log
echo "**********************************************************" >> /var/log/emergency-powerdown.log
echo "$(date) Critical power level threshold (in mWh) is set to $CRITICAL" >> /var/log/emergency-powerdown.log
echo "$(date) Current battery power (in mWh) is $CURRENT_STATE" >> /var/log/emergency-powerdown.log
echo "$(date) The battery is currently $CHARGING_STATE" >> /var/log/emergency-powerdown.log

# If battery is discharging, immediately unmount external disks
if [ $CHARGING_STATE == "discharging" ]
then
    sync && umount /mnt/disk1 && echo "Unmounting /mnt/disk1" >> /var/log/emergency-powerdown.log
    sync && umount /mnt/disk2 && echo "Unmounting /mnt/disk2" >> /var/log/emergency-powerdown.log
    sync && umount /mnt/maxtor && echo "Unmounting /mnt/maxtor" >> /var/log/emergency-powerdown.log
fi

# If battery is discharging, and remaining power is 
# below critical limit, shutdown guests, then host
if [ $CHARGING_STATE == "discharging" ]
then
    if [ $CURRENT_STATE -lt $CRITICAL ]
    then
       for i in $(vmware-vim-cmd vmsvc/getallvms | cut -d" " -f1 | sed '1d') ;
       do
           vmware-vim-cmd vmsvc/power.off $i
           echo "$(date) Shutting down VM with ID $i" >> /var/log/emergency-powerdown.log
           sleep 5
       done
    echo "$(date) $0 Shutting down $HOSTNAME in 3 minutes" >> /var/log/emergency-powerdown.log
    shutdown -h 3
    fi
else
    echo "$(date) $0 took no action" >> /var/log/emergency-powerdown.log
fi

