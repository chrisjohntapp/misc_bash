#!/bin/bash
# Configuration script for dell

# PowerTop recommended power savings
echo 'echo 1500 > /proc/sys/vm/dirty_writeback_centisecs
echo min_power > /sys/class/scsi_host/host0/link_power_management_policy
echo 0 > /proc/sys/kernel/nmi_watchdog
echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
' >> /etc/rc.local

# setup ntpd
if [ !-f $(type ntpd) ] ; then
    yum install ntp -y
    wait
fi
chkconfig ntpd on
ntpdate pool.ntp.org
service ntpd start

# edit anacrontab
echo '# added by <me>
3	50	mirror.share	rsync -av --delete /media/share /media/backup/
' >> /etc/anacrontab

sed 's/^START.*$/START_HOURS_RANGE=2-6/' /etc/anacrontab
sed 's/^MAILTO.*$/MAILTO=<me>/' /etc/anacrontab

# reduce swappiness (to (possibly) allow swap host disk to spin down)
echo 1 > /proc/sys/vm/swappiness


# mount all filesystems with relatime.  (allows disks to spin down possibly. see http://www.lesswatts.org/tips/disks.php
relatime





