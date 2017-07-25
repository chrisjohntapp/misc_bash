#!/bin/bash
# Fedora 15 on Asus

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

# add LAN clients to /etc/hosts
echo '192.168.1.66 <hostname1>
213.5.180.233 <hostname2>' >> /etc/hosts


