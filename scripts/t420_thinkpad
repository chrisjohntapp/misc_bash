#!/bin/bash
# Configure script: PU_IAS Linux 6.1 on Thinkpad.

# check script is being run interactively
case $- in 
    *i*) : ;;
    *) echo "error: script must be run interactively" ; exit 1 ;;
esac

# set username variable
printf "%s" "Please enter your username: "
read USERNAME

# add user to group 'wheel' (if not already present)
STRING1=$(cat /etc/group | grep 'wheel')
case "$STRING1" in
    *$USERNAME*) echo "$USERNAME is already in group \"wheel\"" ;;
    *) sed 's/wheel.*$/&,$USERNAME/' /etc/group ;;
esac

# install rpmfusion repos
yum localinstall --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-stable.noarch.rpm -y
wait

# Install powersave script
echo '#!/bin/bash
# script to make power saving tweaks when not on ac power.

if [ $(grep -c on-line /proc/acpi/ac_adapter/AC/state) == "1" ] ; then
# ac power mode
	echo 0 > /proc/sys/vm/laptop_mode
	echo 1 > /proc/sys/kernel/nmi_watchdog
	for i in /sys/class/scsi_host/host*/link_power_management_policy ; do
		echo max_performance > $i ;
	done
	for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor ; do
		echo performance > $i
	done
	echo 1500 > /proc/sys/vm/dirty_writeback_centisecs
	echo 0 > /sys/devices/system/cpu/sched_mc_power_savings
else
# battery mode
	echo 5 > /proc/sys/vm/laptop_mode
	echo 0 > /proc/sys/kernel/nmi_watchdog
	for i in /sys/class/scsi_host/host*xinput set-int-prop 12 "Evdev Wheel Emulation" 8 1
xinput set-int-prop 12 "Evdev Wheel Emulation Button" 8 2
xinput set-int-prop 12 "Evdev Wheel Emulation Axes" 8 6 7 4 5
/link_power_management_policy ; do
		echo min_power > $i ;
	done
	for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor ; do
		echo ondemand > $i
	done
	echo 1500 > /proc/sys/vm/dirty_writeback_centisecs
	echo 1 > /sys/devices/system/cpu/sched_mc_power_savings
        echo '' > '/sys/module/snd_hda_intel/parameters/power_save'
        echo 'min_power' > '/sys/class/scsi_host/host0/link_power_management_policy'
        echo 'min_power' > '/sys/class/scsi_host/host5/link_power_management_policy'
        echo 'min_power' > '/sys/class/scsi_host/host3/link_power_management_policy'
        echo 'min_power' > '/sys/class/scsi_host/host1/link_power_management_policy'
        echo 'min_power' > '/sys/class/scsi_host/host2/link_power_management_policy'
        echo 'min_power' > '/sys/class/scsi_host/host4/link_power_management_policy'
        echo 'min_power' > '/sys/class/scsi_host/host1/link_power_management_policy'
	echo 'auto' > '/sys/bus/i2c/devices/i2c-4/device/power/control'
	echo 'auto' > '/sys/bus/usb/devices/1-1.4/power/control'
	echo 'auto' > '/sys/bus/pci/devices/0000:03:00.0/power/control'
	echo 'auto' > '/sys/bus/pci/devices/0000:00:1c.3/power/control'
	echo 'auto' > '/sys/bus/pci/devices/0000:00:00.0/power/control'
	echo 'auto' > '/sys/bus/pci/devices/0000:00:1c.1/power/control'
	echo 'auto' > '/sys/bus/pci/devices/0000:0d:00.3/power/control'
	echo 'auto' > '/sys/bus/pci/devices/0000:00:1d.0/power/control'
	echo 'auto' > '/sys/bus/pci/devices/0000:00:1a.0/power/control'
	echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.2/power/control'
	echo 'auto' > '/sys/bus/pci/devices/0000:00:1c.0/power/control'
	echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.0/power/control'
	echo 'auto' > '/sys/bus/pci/devices/0000:0d:00.0/power/control'
	echo 'auto' > '/sys/bus/pci/devices/0000:00:16.0/power/control'
	echo 'auto' > '/sys/bus/pci/devices/0000:00:1b.0/power/control'
	echo 'auto' > '/sys/bus/pci/devices/0000:00:19.0/power/control'
	echo 'auto' > '/sys/bus/pci/devices/0000:00:1c.4/power/control'
	ethtool -s enp0s25 wol d

fi
' > /etc/pm/power.d/powersave.sh
chmod +x /etc/pm/power.d/powersave.sh

## Setup ntpd
if [ !-f $(type ntpd) ] ; then
    yum install ntp -y
        wait
fi

chkconfig ntpd on
ntpdate pool.ntp.org
service ntpd start


# Edits to ~/.bashrc
echo "# User specific aliases and functions
source ~/.bash-git-prompt/gitprompt.sh

for i in ~/Repos/laputa/misc_bash/libs/*; do
  . $i
done

set -o vi
" >> /home/<my home>/.bashrc

## Change Mailto's
# /etc/anacrontab
# /etc/crontab
# /etc/logwatch/conf/logwatch.conf


# install xinput stuff
yum install xorg-x11-apps sysfsutils -y
wait

# create autostart script and populate it
touch /home/<my home>/bin/startup.sh
echo '#!/bin/bash
xinput set-int-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 8 1
xinput set-int-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 8 2
xinput set-int-prop 12 "Evdev Wheel Emulation Axes" 8 6 7 4 5
synclient TapButton1=1
synclient TapButton2=2
synclient HorizTwoFingerScroll=1
synclient VertTwoFingerScroll=1
synclient EmulateTwoFingerMinW=8
synclient EmulateTwoFingerMinZ=40

sleep 120 && ~/.dropbox-dist/dropboxd
' > /home/<my home>/bin/startup.sh
chmod +x /home/<my home>/bin/startup.sh

echo 'Exec=/home/<my home>/bin/startup.sh' > /home/<my home>/.config/autostart/startup.desktop

# misc stuff
echo '# Trackpoint stuff
echo -n 1 > /sys/devices/platform/i8042/serio1/serio2/press_to_select
' >> /etc/rc.local

find /home/<my home>/ -type d -exec chmod -R g+s {} \;

## Allow user <me> to change cpufreq using gnome widgets
echo '[org.gnome.cpufreqselector]
Identity=unix-user:<me>
Action=org.gnome.cpufreqselector
ResultAny=no
ResultInactive=no
ResultActive=yes
' >> /var/lib/polkit-1/localauthority/50-local.d/org.gnome.cpufreqselector.pkla
xinput set-int-prop 12 "Evdev Wheel Emulation" 8 1
xinput set-int-prop 12 "Evdev Wheel Emulation Button" 8 2
xinput set-int-prop 12 "Evdev Wheel Emulation Axes" 8 6 7 4 5

# Set laptop mode in rc.local
echo 'echo 5 > /proc/sys/vm/laptop_mode' >> /etc/rc.local

# Change filesystem fsck to once per 50 mounts
mount > /tmp/mounts
ROOTFS=$(grep "on / " /tmp/mounts | cut -d " " -f 1)
/sbin/tune2fs -c 50 $ROOTFS

# PowerTop recommendations.

##### Stuff I can't script #####
# in gconf-editor change desktop/gnome/peripherals/touchpad/scroll_method to "2".

#EOF






